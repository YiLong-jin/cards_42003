--RHYTHM SKY MIRROR
function c65846959.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846959+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c65846959.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846959,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c65846959.spcon)
	e2:SetTarget(c65846959.tdtg)
	e2:SetOperation(c65846959.tgop)
	c:RegisterEffect(e2)
end
function c65846959.thfilter(c,e,sp)
	return c:IsSetCard(0x23e0) and c:IsAbleToHand() and c:IsType(0x1)
end
function c65846959.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c65846959.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65846959,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c65846959.xyzfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ)
end
function c65846959.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65846959.xyzfilter2,1,nil,tp) 
end
function c65846959.tdfilter(c)
	return (c:IsSetCard(0x23e0) or c:IsType(TYPE_XYZ)) and c:IsAbleToDeck()
end
function c65846959.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846959.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846959.tdfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.GetFlagEffect(tp,65846959)==0 end
	Duel.RegisterFlagEffect(tp,65846959,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65846959.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c65846959.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65846959.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(aux.NecroValleyFilter(Card.IsRelateToEffect),nil,e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	if not Duel.IsExistingMatchingCard(c65846959.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
	