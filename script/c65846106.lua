--彩虹 云彩
function c65846106.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846106+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65846106.cost)
	e1:SetTarget(c65846106.target)
	e1:SetOperation(c65846106.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846106,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65846106.tdtg)
	e2:SetOperation(c65846106.tdop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(65846106,ACTIVITY_CHAIN,aux.FilterBoolFunction(aux.NOT(Effect.IsActiveType),0x7))
end
c65846106.SetCard_ZJ_CH=true
function c65846106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c65846106.filter(c)
	return c.SetCard_ZJ_CH and c:IsType(0x1) and c:IsAbleToHand()
end
function c65846106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846106.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65846106.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846106.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then		
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetCustomActivityCount(65846106,1-tp,ACTIVITY_CHAIN)~=0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and g:GetFirst():IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(65846106,0)) then
			Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65846106.tdfilter(c)
	return (c:IsRace(0x4) or c:IsType(TYPE_SYNCHRO)) and c:IsAbleToDeck() and c:IsFaceup()
end
function c65846106.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c65846106.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846106.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,e:GetHandler()) and Duel.GetFlagEffect(tp,65846106)==0 end
	Duel.RegisterFlagEffect(tp,65846106,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65846106.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c65846106.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
