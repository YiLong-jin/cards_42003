--介于成熟和天真之间
function c9878042.initial_effect(c)
	aux.AddCodeList(c,9878030,9877883)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9878042,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9878042+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9878042.cost)
	e1:SetTarget(c9878042.destg)
	e1:SetOperation(c9878042.desop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9878042,ACTIVITY_SPSUMMON,c9878042.counterfilter)
end
function c9878042.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function c9878042.cfilter(c)
	 return aux.IsCodeListed(c,9877883) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9878042.thfilter(c)
	return aux.IsCodeListed(c,9878030) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c9878042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetCustomActivityCount(9878042,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9878042.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9878042.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c9878042.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878042.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c9878042.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9878042.desop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9878042.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	 local g1=Duel.SelectMatchingCard(tp,c9878042.cfilter,tp,LOCATION_DECK,0,1,1,nil) 
		  if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		 end
	 end
end
