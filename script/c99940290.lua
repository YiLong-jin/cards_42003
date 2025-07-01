--情怀的悲剧
function c99940290.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99940290,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99940290)
	e1:SetCost(c99940290.cost)
	e1:SetTarget(c99940290.target)
	e1:SetOperation(c99940290.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99940290,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99940291)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c99940290.thtg)
	e2:SetOperation(c99940290.thop)
	c:RegisterEffect(e2)
---------------------------------------------------------------------------------------------------------------------------
end
function c99940290.cfilter(c,tp)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c99940290.filter,tp,LOCATION_DECK,0,1,c)
end
function c99940290.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940290.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99940290.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99940290.filter(c)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c99940290.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940290.filter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c99940290.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c99940290.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
---------------------------------------------------------------------------------------------------------------------------
function c99940290.thfilter(c)
	return c:IsFaceup() and c:IsAttack(1550) and c:IsDefense(1550) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c99940290.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940290.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c99940290.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99940290.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end