-- 伊芙利特092
local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- 灵摆效果（不取对象）
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- 怪兽效果①
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1, id + 1)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)

    -- 怪兽效果②（盖放速攻）
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_SSET)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1, id + 2)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)
end

-- ========== 灵摆效果 ==========
function s.pen_filter(c)
    if not c:IsSetCard(0x671) then return false end
    if c:IsLocation(LOCATION_EXTRA) then
        return c:IsFaceup()
    end
    return true
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.pen_filter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE + LOCATION_EXTRA)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.pen_filter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
    if c:IsRelateToEffect(e) then
        Duel.Destroy(c, REASON_EFFECT)
    end
end

-- ========== 怪兽效果① ==========
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.destroyed_filter, 1, nil, tp)
end

function s.destroyed_filter(c, tp)
    return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) == 0 then return end

    local g_extra = Duel.GetMatchingGroup(s.spfilter_extra, tp, LOCATION_EXTRA, 0, nil, e, tp)
    local g_grave = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter_grave), tp, LOCATION_GRAVE, 0, nil, e, tp)

    local g = Group.CreateGroup()
    g:Merge(g_extra)
    g:Merge(g_grave)

    if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local sg = g:Select(tp, 1, 1, nil)
        if #sg > 0 then
            Duel.SpecialSummon(sg:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)
        end
    end
end

function s.spfilter_extra(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
        and c:IsFaceup() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
end

function s.spfilter_grave(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
end

-- ========== 怪兽效果② ==========
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.desfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_SSET, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.desfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.desfilter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        local tc = g:GetFirst()
        Duel.SSet(tp, tc)

        -- 当回合可以发动
        local e2 = Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
        tc:RegisterEffect(e2)
    end
end