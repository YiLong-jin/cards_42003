--休暇的情怀
function c99940370.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c99940370.lcheck) 

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99940370,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99940370)
	e1:SetCost(c99940370.cost)
	e1:SetTarget(c99940370.target)
	e1:SetOperation(c99940370.operation)
	c:RegisterEffect(e1)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,99940371)
	e5:SetCost(c99940370.thcost)
	e5:SetTarget(c99940370.thtg)
	e5:SetOperation(c99940370.thop)
	c:RegisterEffect(e5)
end
-------------------------------------------------------------------------------------------------------
function c99940370.lcheck(g)
	return g:IsExists(Card.IsAttack,1,nil,1550)
end
-------------------------------------------------------------------------------------------------------
function c99940370.cfilter(c)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsAbleToGraveAsCost()
end
function c99940370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940370.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99940370.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99940370.filter(c)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsAbleToHand()
end
function c99940370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940370.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99940370.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99940370.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-----------------------------------------------------------------------------------------------------
function c99940370.cfilters(c)
	return c:IsDiscardable()
end
function c99940370.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c99940370.cfilters,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c99940370.cfilters,1,1,REASON_COST+REASON_DISCARD)
end
function c99940370.filters(c)
	return c:IsCode(99940380) and c:IsAbleToHand()
end
function c99940370.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940370.filters,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99940370.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c99940370.filters,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
