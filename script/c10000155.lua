--耐莉
local s, id, o = GetID()

function s.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1, id + 10000000)
    e1:SetCost(s.generalcost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_SUMMON + CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
    e2:SetCost(s.generalcost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_NORMALSUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
end

function s.counterfilter(c)
    return ((c:GetSummonLocation() & (LOCATION_HAND | LOCATION_DECK)) == 0) or c:IsAttribute(ATTRIBUTE_DARK)
end

function s.generalcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetCustomActivityCount(id, tp, ACTIVITY_SUMMON) == 0 and Duel.GetCustomActivityCount(id, tp, ACTIVITY_NORMALSUMMON) == 0 and Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) == 0
    end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE + PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1, tp)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2, tp)
end

function s.sumlimit(e, c, sump, sumtype, sumpos, targetp, se)
    return c:IsLocation(LOCATION_HAND | LOCATION_DECK) and (not c:IsAttribute(ATTRIBUTE_DARK))
end

function s.thfilter(c)
    return c:IsSetCard(0xafe4) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

function s.sumfilter(c)
    return c:IsSetCard(0xafe4) and c:IsSummonable(true, nil)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.sumfilter, tp, LOCATION_HAND, 0, 1, nil) and Duel.IsExistingMatchingCard(Card.IsDestructable, tp, LOCATION_MZONE, 0, 1, nil, e)
    end
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 1, tp, LOCATION_HAND)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, tp, LOCATION_MZONE)
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SUMMON)
    local g = Duel.SelectMatchingCard(tp, s.sumfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
    if #g > 0 then
        Duel.Summon(tp, g:GetFirst(), true, nil)
        local rg = Duel.GetMatchingGroup(Card.IsDestructable, tp, LOCATION_MZONE, 0, nil, e)
        if #rg > 0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
            local mg = rg:Select(tp, 1, 1, nil)
            Duel.Destroy(mg, REASON_EFFECT)
        end
    end
end