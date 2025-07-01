--狩魂×灵魂旋律
function c69969407.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969407,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,69969407+EFFECT_COUNT_CODE_OATH)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c69969407.mattg)
	e4:SetOperation(c69969407.matop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969407,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MOVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,69969411)
	e5:SetCondition(c69969407.spcon2)
	e5:SetTarget(c69969407.cattg)
	e5:SetOperation(c69969407.catop)
	c:RegisterEffect(e5)
end
function c69969407.matfilter2(c)
	return c:IsCanOverlay() and c:IsSetCard(0x69d)
end
function c69969407.matfilter(c,tp)
	return c:IsFaceup() and c:IsRank(4) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c69969407.matfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function c69969407.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69969407.matfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969407.matfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c69969407.matfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c69969407.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c69969407.matfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc)
		if #g>0 then
			Duel.Overlay(tc,g)
			Duel.Recover(tp,500,REASON_EFFECT)
		end
	end
end
--2
function c69969407.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c69969407.catfilter2(c)
	return c:IsCanOverlay() and c:IsSetCard(0x69d) and not c:IsCode(69969407) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c69969407.catfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x69d) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c69969407.catfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function c69969407.cattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69969407.catfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969407.catfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c69969407.catfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c69969407.catop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c69969407.catfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil,tc)
		if #g>0 then
			Duel.Overlay(tc,g)
		end
	end
end