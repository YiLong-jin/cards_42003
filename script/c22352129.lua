--高驱动龙属性扩散
function c22352129.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22352129,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,22352129)
	e2:SetTarget(c22352129.atrtg)
	e2:SetOperation(c22352129.atrop)
	c:RegisterEffect(e2)
end
function c22352129.atrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-g:GetFirst():GetAttribute())
	e:SetLabel(att)
end
function c22352129.thfilter(c,e,tp,ft)
	return c:IsSetCard(0xc29) and c:IsType(TYPE_MONSTER) and (c:IsAbleToDeck() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c22352129.atrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local att=e:GetLabel()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and not tc:IsAttribute(att) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22352129.thfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) and Duel.SelectYesNo(tp,aux.Stringid(22352129,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22352129.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
			local sc=g:GetFirst()
			if ft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not sc:IsAbleToDeck() or Duel.SelectOption(tp,aux.Stringid(22352129,3),1152)==1) then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.HintSelection(g)
				Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end