--辛德雷
local s, id, o = GetID()

function s.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_NEGATE + CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.discon)
    e1:SetCost(s.generalcost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SUMMON + CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, id + 10000000)
    e2:SetCondition(s.spcon)
    e2:SetCost(s.generalcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id, ACTIVITY_SUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_NORMALSUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
end

function s.counterfilter(c)
    return ((c:GetSummonLocation() & (LOCATION_HAND | LOCATION_DECK)) == 0) or c:IsAttribute(ATTRIBUTE_DARK)
end

function s.discon(e, tp, eg, ep, ev, re, r, rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL) and e:GetHandler():IsLocation(LOCATION_MZONE) and rp == 1 - tp
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

function s.distg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then
        return e:GetHandler():IsAbleToRemove() and e:GetHandler():IsLocation(LOCATION_MZONE)
    end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp, chk)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_EFFECT) > 0 then
        Duel.BreakEffect()
        Duel.NegateActivation(ev)
    end
end

function s.cfilter(c, tp)
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.cfilter, 1, nil, tp)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetMZoneCount(tp) > 0 and e:GetHandler():IsAbleToHand()
    end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c, tp, REASON_EFFECT) > 0 and c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp) > 0 and c:IsSummonable(true, nil) then
		Duel.BreakEffect()
    	Duel.Summon(tp, c, true, nil)
	end
end

function s.sumlimit(e, c, sump, sumtype, sumpos, targetp, se)
    return c:IsLocation(LOCATION_HAND | LOCATION_DECK) and (not c:IsAttribute(ATTRIBUTE_DARK))
end