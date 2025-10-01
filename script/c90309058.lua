--暗黑界的混沌
function c90309058.initial_effect(c)
 --link summon
	aux.AddLinkProcedure(c,nil,2,2,c90309058.lcheck)
	c:EnableReviveLimit()  
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90309058,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,90309058)
	e1:SetTarget(c90309058.thtg)
	e1:SetOperation(c90309058.thop)
	c:RegisterEffect(e1) 
end
function c90309058.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6)
end
function c90309058.filter(c)
	return c:IsCode(33017655) and c:IsAbleToHand()
end
function c90309058.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90309058.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c90309058.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.SelectMatchingCard(tp,c90309058.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
