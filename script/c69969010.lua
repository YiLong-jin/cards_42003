--★M1
function c69969010.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,69969010+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c69969010.target)
	e1:SetOperation(c69969010.operation)
	c:RegisterEffect(e1)
end
function c69969010.filter(c)
	return c:IsSetCard(0x699) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c69969010.xfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:GetBaseAttack()==1850
end
function c69969010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c69969010.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c69969010.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectTarget(tp,c69969010.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,300)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,0)
end
function c69969010.hfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c69969010.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969010.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Damage(tp,300,REASON_EFFECT) end 
	   local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(c69969010.hfilter,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local tc=g:GetFirst()
		while tc do
			if tc:IsLocation(LOCATION_HAND) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(c69969010.aclimit)
				e1:SetLabel(tc:GetCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
		 Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
			end
		   tc=g:GetNext()
		end 
	end
end
function c69969010.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end