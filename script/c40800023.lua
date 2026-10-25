--芝士 终焉七海莉雅
local s, id, o = GetID()

function s.initial_effect(c)
    aux.AddXyzProcedure(c, s.filter, 4, 2)
    c:EnableReviveLimit()

    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,id + 10000000)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end
s.SetCard_RR_ZS = true -- 注册自定义字段逻辑

function s.filter(c)
    return c.SetCard_RR_ZS
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() and c:IsSummonType(SUMMON_TYPE_XYZ) end
    local ct=c:GetOverlayCount()
    Duel.Release(c,REASON_COST)
    e:SetLabel(ct)
end

function s.filterxyz(c, e, tp, rc)
    return c.SetCard_RR_ZS and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and Duel.GetLocationCountFromEx(tp, tp, rc, c) > 0
end

function s.mtfilter(c,e)
    return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filterxyz,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel() + 1
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filterxyz,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
    if #g>0 then
        local tc=g:GetFirst()
        local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mtfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,tc,e)
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and ct>0
            and #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
            local xg=mg:Select(tp,1,ct,nil)
            local tc1=xg:GetFirst()
            while tc1 do
                tc1:CancelToGrave()
                local og=tc1:GetOverlayGroup()
                if #og>0 then
                    Duel.SendtoGrave(og,REASON_RULE)
                end
                tc1=xg:GetNext()
            end
            Duel.Overlay(tc,xg)
        end
    end
end

function s.filterth(c)
    return c.SetCard_RR_ZS and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filterth,tp,LOCATION_DECK + LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK + LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filterth),tp,LOCATION_DECK + LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end