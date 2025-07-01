--芝士 灵堂
function c40800016.initial_effect(c)
	aux.AddCodeList(c,40800000)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40800016+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c40800016.activate)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c40800016.tdtg)
	e2:SetOperation(c40800016.tdop)
	c:RegisterEffect(e2) 
end
c40800016.SetCard_RR_ZS=true 
function c40800016.thfilter(c)
	return c.SetCard_RR_ZS and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40800016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40800016.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40800016,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c40800016.filter(c)
	return c:IsCode(40800000) and c:IsFaceup() and c:IsAbleToDeck()
end
function c40800016.fselect(c)
	return c:IsCode(40800000) and c:IsAbleToDeck()
end
function c40800016.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40800016.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c40800016.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:FilterSelect(tp,c40800016.fselect,1,5,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40800016.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
		Duel.ShuffleDeck(tp) 
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end