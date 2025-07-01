--芝士 陷阱
function c40800012.initial_effect(c)
	aux.AddCodeList(c,40800000)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40800012)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40800012.cost)
	e1:SetTarget(c40800012.target)
	e1:SetOperation(c40800012.activate)
	c:RegisterEffect(e1)	
end
c40800012.SetCard_RR_ZS=true 
function c40800012.costfilter(c)
	return (c:IsCode(40800000) and c:IsAbleToGraveAsCost() and c:IsLocation(LOCATION_EXTRA) or c.SetCard_RR_ZS and c:IsLocation(LOCATION_HAND) and c:IsDiscardable())
end
function c40800012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40800012.costfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c40800012.costfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_EXTRA) then
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function c40800012.tgf(c)
	return aux.NegateAnyFilter(c) and c:IsType(TYPE_SPELL+TYPE_MONSTER)
end
function c40800012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c40800012.tgf(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c40800012.tgf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c40800012.tgf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c40800012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end