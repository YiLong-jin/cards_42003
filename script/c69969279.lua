--交响曲·阿伊达
function c69969279.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),6,2)
	c:EnableReviveLimit()
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969279,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c69969279.rmcon)
	e1:SetCost(c69969279.cost)
	e1:SetTarget(c69969279.thtg)
	e1:SetOperation(c69969279.thop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969279,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCondition(c69969279.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c69969279.sptg)
	e2:SetOperation(c69969279.spop)
	c:RegisterEffect(e2)
end
function c69969279.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(69969279)==0
end
function c69969279.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69969279.thfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToHand() and c:IsLevel(5,6,7)
end
function c69969279.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969279.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69969279.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969279.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(69969279,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		 end
	end
end
--2
function c69969279.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return #eg==1 and tc:IsPreviousControler(tp) and tc:IsPreviousLocation(LOCATION_MZONE)
		and tc:GetReasonPlayer()==1-tp and tc:IsReason(REASON_EFFECT)
end
function c69969279.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsAbleToDeck() end
	local c=e:GetHandler()
	c:CreateEffectRelation(e)
	Duel.SetTargetCard(tc)
	local g=Group.FromCards(c,tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c69969279.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and tc:IsFaceupEx() then
		if aux.NecroValleyNegateCheck(tc) then return end
		if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then
		   Duel.Damage(1-tp,1000,REASON_EFFECT) end
	elseif c:IsRelateToEffect(e) and c:IsLocation(LOCATION_REMOVED) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) then
		   Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
end




