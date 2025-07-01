--断罪神裁判
function c10701655.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10701655+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10701655.condition)
	e1:SetTarget(c10701655.target)
	e1:SetOperation(c10701655.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10701656)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10701655.thtg)
	e2:SetOperation(c10701655.thop)
	c:RegisterEffect(e2)   
end
function c10701655.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) 
		and Duel.IsChainNegatable(ev)
end
function c10701655.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701655.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701655.filter(c)
	return c:IsAttack(2800) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c10701655.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701655.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	   if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	   end
	end
end
function c10701655.thfilter(c)
	return c:IsFaceupEx() and (c:IsSetCard(0x7c0) or c:IsCode(24857466)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10701655.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701655.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10701655.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701655.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end