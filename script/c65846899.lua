--超可爱执行者·救火女
function c65846899.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,65846891+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65846899.spcon)
	c:RegisterEffect(e1)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c65846899.settg)
	e3:SetOperation(c65846899.setop)
	c:RegisterEffect(e3)	
end
c65846899.SetCard_ZJ_CKAZXZ=true
function c65846899.filter(c)
	return c:GetBaseDefense()==500 and c:IsFaceup()
end
function c65846899.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846899.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c65846899.cfilter(c)
	return c:IsType(0x6) and c.SetCard_ZJ_CKAZXZ and c:IsAbleToDeck()
end
function c65846899.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846899.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65846899.cfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c65846899.stfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c65846899.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846899.cfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65846899.stfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c65846899.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,65846899)==0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65846899.cfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.RegisterFlagEffect(tp,65846899,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c65846899.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65846899.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end