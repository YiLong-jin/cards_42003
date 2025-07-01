--超可爱执行者联合！
function c65846901.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846901+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65846901.target)
	e1:SetOperation(c65846901.activate)
	c:RegisterEffect(e1)	
end
c65846901.SetCard_ZJ_CKAZXZ=true 
function c65846901.thfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand() 
end
function c65846901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c65846901.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return -- c:IsLevel(6) and c:IsDefense(500) and 
	c:IsAbleToGrave() end,tp,LOCATION_HAND,0,1,e:GetHandler()) and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c65846901.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,function(c) return  --:IsLevel(6) and c:IsDefense(500) and 
	c:IsAbleToGrave() end,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	local ag=Duel.GetMatchingGroup(c65846901.thfilter,tp,LOCATION_DECK,0,nil)
	if ag:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=ag:SelectSubGroup(tp,aux.dabcheck,false,2,2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end