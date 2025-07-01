--后发制敌
local s, id, o = GetID()

function s.initial_effect(c)
	aux.AddCodeList(c, 10000135)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.ngcon)
    e1:SetTarget(s.ngtarg)
    e1:SetOperation(s.ngop)
    e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_DISABLE)
    c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
    e2:SetCost(s.setcost)
    e2:SetTarget(s.settarget)
    e2:SetOperation(s.setoperation)
    e2:SetCountLimit(1, id + 10000000)
    c:RegisterEffect(e2)
end

function s.ngcon(e, tp, eg, ep, ev, re, r, rp)
    local ph = Duel.GetCurrentPhase()
    return ph == PHASE_MAIN1 or ph == PHASE_MAIN2 or (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE) 
        and (Duel.GetTurnPlayer() == tp or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 10000135))
end

function s.ngfilter(c)
    return c:IsCode(10000135) and c:IsAbleToGrave()
end

function s.ngtarg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter, tp, 0, LOCATION_MZONE, 1, nil) and Duel.IsExistingMatchingCard(s.ngfilter, tp, LOCATION_ONFIELD, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_ONFIELD)
end

function s.ngop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.ngfilter, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
    if #g > 0 and Duel.SendtoGrave(g, REASON_EFFECT) > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISABLE)
        local tg = Duel.SelectMatchingCard(tp, aux.NegateMonsterFilter, tp, 0, LOCATION_MZONE, 1, 1, nil)
        local tc = tg:GetFirst()
        if tc and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
            Duel.BreakEffect()
            Duel.NegateRelatedChain(tc, RESET_TURN_SET)
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2 = Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            e2:SetReset(RESET_EVENT + RESETS_STANDARD)
            tc:RegisterEffect(e2)
        end
    end
end

function s.setcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(), nil, 2, REASON_COST)
end

function s.setfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xbdef) and c:IsSSetable()
end

function s.settarget(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
end

function s.setoperation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
    local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    Duel.SSet(tp, g)
end