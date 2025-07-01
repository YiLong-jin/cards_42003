--念力作曲
function c65846704.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3211439,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,65846704)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65846704.thtg)
	e1:SetOperation(c65846704.thop)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4779823,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,65846704+231217)
	e2:SetTarget(c65846704.target)
	e2:SetOperation(c65846704.activate)
	c:RegisterEffect(e2)  
end
--[[function c65846704.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_FUSION)
end
function c65846704.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c65846704.cfilter,1,nil,tp)
end
function c65846704.cfilter2(c,e)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
		and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE)
end
function c65846704.thfilter(c)
	return (aux.IsCodeListed(c,65846684) or aux.IsCodeListed(c,65846688)) and c:IsType(0x1) and c:IsAbleToHand()
end
function c65846704.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(c65846704.cfilter2,1,nil,e)
		and Duel.IsExistingMatchingCard(c65846704.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=eg:Filter(c65846704.cfilter2,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65846704.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65846704.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end]]
function c65846704.thfilter(c)
	return (c:IsCode(24094653) or c:IsType(TYPE_NORMAL)) and c:IsAbleToHand()
end
function c65846704.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846704.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846704.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c65846704.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65846704.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c65846704.filter(c)
	return (aux.IsCodeOrListed(c,65846670) or c:IsSetCard(0x3ea) or c:IsSetCard(0x46)) and c:IsFaceup() and c:IsAbleToDeck()
end
function c65846704.fselect(g)
	return g:FilterCount(function(c) return c:IsFaceup() and (aux.IsCodeListed(c,65846670) or aux.IsCodeListed(c,65846686) or c:IsSetCard(0x3ea) or c:IsSetCard(0x46)) end,nil)>0
end
function c65846704.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c65846704.filter(chkc) end
	if chk==0 then return --[[Duel.IsPlayerCanDraw(tp,1)
		and ]]Duel.IsExistingTarget(c65846704.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c65846704.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c65846704.fselect,false,1,5,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	--Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65846704.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	--[[local sg=Duel.GetOperatedGroup()
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
		Duel.ShuffleDeck(tp) 
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end]]
end