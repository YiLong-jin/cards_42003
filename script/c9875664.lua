--薇特莉斯甜点工坊-熊熊美食家
function c9875664.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x7ef),2,2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9875664,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9875664)
	e1:SetTarget(c9875664.lthtg)
	e1:SetOperation(c9875664.lthop)
	c:RegisterEffect(e1) 
end
function c9875664.lthfilter(c)
	return c:IsSetCard(0x17e4) and c:IsAbleToHand()
end 
function c9875664.lthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9875664.lthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9875664.lthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9875664.lthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end