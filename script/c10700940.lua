--超气魄近接格斗术
function c10700940.initial_effect(c)
	aux.AddCodeList(c,10700910,10700915)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700940+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10700940.cost)
	e1:SetTarget(c10700940.target)
	e1:SetOperation(c10700940.activate)
	c:RegisterEffect(e1)   
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700930,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,10700941)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700940.thtg)
	e2:SetOperation(c10700940.thop)
	c:RegisterEffect(e2)	 
end
function c10700940.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c10700940.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND+LOCATION_ONFIELD 
	if fe then loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700940.costfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700940.costfilter,tp,loc,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700940.cfilter1(c)
	return c:IsFaceup() and c:IsCode(10700910)
end
function c10700940.setfilter(c)
	return c:IsSetCard(0x7cd) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c10700940.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return ft>0 and Duel.IsExistingMatchingCard(c10700940.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
end
function c10700940.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c10700940.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700940.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c10700940.indtg)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(c10700940.tgfilter,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c10700940.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
		and g:GetCount()>0 
		and Duel.SelectYesNo(tp,aux.Stringid(10700940,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c10700940.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10700940.thfilter(c)
	return c:IsCode(10700915) and c:IsAbleToHand()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10700940.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c10700940.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700940.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700940.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	if Duel.IsExistingMatchingCard(c10700940.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetLabel(0)
	end
end
function c10700940.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	 Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end