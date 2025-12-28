--愿我们的心意不再相悖
local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCategory(CATEGORY_RECOVER + CATEGORY_DESTROY)
    e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
    e1:SetHintTiming(0, TIMING_BATTLE_START + TIMING_BATTLE_END)
    e1:SetCondition(s.cond)
    e1:SetTarget(s.targ)
    e1:SetOperation(s.ope)
    c:RegisterEffect(e1)
end

function s.cond(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetCurrentPhase() >= PHASE_BATTLE_START and Duel.GetCurrentPhase() <= PHASE_BATTLE
end

function s.filter(c, e)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0xafe4) and Duel.GetMatchingGroupCount(Card.IsDestructable, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, c, e) > 0 and c:IsFaceup()
end

function s.targ(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return s.filter(chkc, e) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.filter, tp, LOCATION_MZONE, 0, 1, nil, e)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil, e)
    local tc = g:GetFirst()
    local desg = Duel.GetMatchingGroup(Card.IsDestructable, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, tc, e)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, desg, #desg, 0, 0)
end

function s.ope(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local desg = Duel.GetMatchingGroup(Card.IsDestructable, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, tc, e)
    if desg and #desg > 0 and Duel.Destroy(desg, REASON_EFFECT) > 0 then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_REVERSE_DAMAGE)
        e1:SetTargetRange(1,0)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
end