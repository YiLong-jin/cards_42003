--净源圣职
function c71100328.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,71100328)
	e1:SetCondition(c71100328.spcon)
	e1:SetTarget(c71100328.sptg)
	e1:SetOperation(c71100328.spop)
	c:RegisterEffect(e1)	
end
function c71100328.cfilter(c)
	return c:IsFaceup()
end
function c71100328.spcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c71100328.cfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c71100328.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentChain()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100328.filter(c,type)
	return c:IsType(type) and c:IsFaceup()
end
function c71100328.tgfilter(c)
	return c:IsSetCard(0x47df) and c:IsAbleToGrave()
end
function c71100328.thfilter(c)
	return c:IsSetCard(0x47df) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71100328.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local f1=Duel.IsExistingMatchingCard(c71100328.filter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_MONSTER) and Duel.IsExistingMatchingCard(c71100328.thfilter,tp,LOCATION_DECK,0,1,nil)
		local f2=Duel.IsExistingMatchingCard(c71100328.filter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL) and Duel.IsExistingMatchingCard(c71100328.tgfilter,tp,LOCATION_DECK,0,1,nil)
		local f3=Duel.IsExistingMatchingCard(c71100328.filter,tp,0,LOCATION_ONFIELD,1,nil,TYPE_TRAP) and Duel.IsExistingMatchingCard(c71100328.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		if f2 and Duel.SelectYesNo(tp,aux.Stringid(71100328,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=Duel.SelectMatchingCard(tp,c71100328.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()>0 then
			  Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
		if f1 and Duel.SelectYesNo(tp,aux.Stringid(71100328,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local hg=Duel.SelectMatchingCard(tp,c71100328.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if hg:GetCount()>0 then
			  Duel.SendtoHand(hg,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,hg)
			end
		end
		if f3 and Duel.SelectYesNo(tp,aux.Stringid(71100328,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c71100328.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
			if g:GetCount()>0 then
			  Duel.SendtoHand(g,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,g)
		   end
		end
	end
end