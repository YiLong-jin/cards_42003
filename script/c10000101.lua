--旌旗卷舒
function c10000101.initial_effect(c)
	--magic
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+LOCATION_DECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10000101+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10000101.target)
	e1:SetOperation(c10000101.activate)
	c:RegisterEffect(e1)
	--
	
end
function c10000101.thfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0xafe0)
end
function c10000101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10000101.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10000101.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10000101.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
