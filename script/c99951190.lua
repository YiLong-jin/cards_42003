-- ATL-1
local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- 灵摆效果（标签 id）
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pencon)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- 怪兽效果①：召唤成功（标签 id+1）
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.smtg)
    e2:SetOperation(s.smop)
    c:RegisterEffect(e2)

    local e3 = e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)

    -- 怪兽效果②：作为同调素材时赋予效果
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BE_MATERIAL)
    e4:SetCondition(s.matcon)
    e4:SetOperation(s.matop)
    c:RegisterEffect(e4)
end

-- ========== 灵摆效果 ==========
function s.pencon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local pzone = Duel.GetFieldGroup(tp, LOCATION_PZONE, 0)
    if pzone:GetCount() < 2 then return false end
    local other = pzone:GetFirst()
    if other == c then other = pzone:GetNext() end
    return other and other:IsSetCard(0x671)
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 0, tp, LOCATION_PZONE)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.penfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    local pzone_group = Duel.GetFieldGroup(tp, LOCATION_PZONE, 0)
    if #pzone_group == 0 then return end
    Duel.Destroy(pzone_group, REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

-- ========== 怪兽效果① ==========
-- ★ 参考陨火龙：对灵摆区只检查 IsCanBeSpecialSummoned，不检查 IsType(TYPE_MONSTER)
function s.smfilter_extra(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE)
        and c:IsFaceup() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
end

-- ★ 灵摆区：完全参考陨火龙的写法，只检查 IsCanBeSpecialSummoned + 字段+种族
function s.smfilter_pzone(c, e, tp)
    return c:IsSetCard(0x671) and c:IsRace(RACE_MACHINE)
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
end

function s.smtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local has_extra = Duel.IsExistingMatchingCard(s.smfilter_extra, tp, LOCATION_EXTRA, 0, 1, nil, e, tp)
        local has_pzone = Duel.IsExistingMatchingCard(s.smfilter_pzone, tp, LOCATION_PZONE, 0, 1, nil, e, tp)
        return has_extra or has_pzone
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA + LOCATION_PZONE)
end

function s.smop(e, tp, eg, ep, ev, re, r, rp)
    local g_extra = Duel.GetMatchingGroup(s.smfilter_extra, tp, LOCATION_EXTRA, 0, nil, e, tp)
    local g_pzone = Duel.GetMatchingGroup(s.smfilter_pzone, tp, LOCATION_PZONE, 0, nil, e, tp)
    
    local g = Group.CreateGroup()
    g:Merge(g_extra)
    g:Merge(g_pzone)
    
    if #g == 0 then return end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg = g:Select(tp, 1, 1, nil)
    if #sg > 0 then
        local tc = sg:GetFirst()
        Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ========== 怪兽效果②：赋予同调怪兽效果 ==========
function s.matcon(e, tp, eg, ep, ev, re, r, rp)
    local rc = e:GetHandler():GetReasonCard()
    return r == REASON_SYNCHRO and rc and rc:IsSetCard(0x671)
end

function s.matop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local rc = c:GetReasonCard()
    if not rc then return end

    local e1 = Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(id, 2))
    e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.synctg)
    e1:SetOperation(s.syncop)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
    rc:RegisterEffect(e1, true)

    if not rc:IsType(TYPE_EFFECT) then
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD)
        rc:RegisterEffect(e2, true)
    end

    rc:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 3))
end

function s.synctg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.syncfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.syncfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:GetLevel() <= 4 and c:IsAbleToHand()
end

function s.syncop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.syncfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        local tc = g:GetFirst()
        Duel.SendtoHand(tc, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, tc)

        local hand = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
        if #hand > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
            local sg = hand:Select(tp, 1, 1, nil)
            if #sg > 0 then
                Duel.SendtoDeck(sg, nil, SEQ_DECKTOP, REASON_EFFECT)
            end
        end
    end
end