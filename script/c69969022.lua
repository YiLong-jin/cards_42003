--思念体超越
function c69969022.initial_effect(c)
	--2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969022,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,69969022)
	e1:SetCondition(c69969022.sprcon)
	e1:SetTarget(c69969022.thtg)
	e1:SetOperation(c69969022.thop)
	c:RegisterEffect(e1)
	--3
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969022,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,69969024)
	e2:SetCondition(aux.dscon)
	e2:SetTarget(c69969022.target)
	e2:SetOperation(c69969022.activate)
	c:RegisterEffect(e2)
	--1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969022,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,69969025)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c69969022.gtarget)
	e3:SetOperation(c69969022.gactivate)
	c:RegisterEffect(e3)
end
--1
function c69969022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x699)
end
function c69969022.sprcon(e,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c69969022.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c69969022.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c69969022.xfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:GetOverlayGroup():IsExists(c69969022.thfilter,1,nil,e,tp) 
end
function c69969022.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c69969022.xfilter(chkc.tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969022.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c69969022.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c69969022.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mg=tc:GetOverlayGroup():Filter(c69969022.thfilter,nil,e,tp)
	if tc:IsRelateToEffect(e) and #mg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
--2
function c69969022.tarfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x699)
end
function c69969022.exfilter(c)
	return c:IsSetCard(0x699) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and
	c:IsType(TYPE_MONSTER)
end
function c69969022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69969022.tarfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969022.tarfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c69969022.exfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c69969022.tarfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local g=Duel.GetMatchingGroup(c69969022.exfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c69969022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c69969022.exfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and g:GetCount()>0 then
	local rc=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(500*rc)
		tc:RegisterEffect(e1)
	end
end
--3
function c69969022.agspfilter(c,tp,chk)
	return c:IsAbleToDeck() and c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and not c:IsCode(69969022)
end
function c69969022.ggfilter(c)
	return c:IsSetCard(0x699) and c:IsAbleToHand()
end
function c69969022.gtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969022.ggfilter,tp,LOCATION_DECK,0,1,nil)
	and Duel.IsExistingMatchingCard(c69969022.agspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp,true)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c69969022.gactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=nil
	if Duel.IsExistingMatchingCard(c69969022.agspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp,true) then
		rg=Duel.SelectMatchingCard(tp,c69969022.agspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp,true)
	else
		rg=Duel.SelectMatchingCard(tp,c69969022.agspfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp,false)
	end
	if rg and rg:GetCount()>0 then
		if rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,rg)
		else
			Duel.HintSelection(rg)
		end
		if Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
			and rg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)>0
			then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969022.ggfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(69969022,3)) then
		Duel.Damage(tp,300,REASON_EFFECT)
		else
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
end
end 
end
end
end