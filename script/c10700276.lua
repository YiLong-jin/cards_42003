--奇术师 愚人节荷官
function c10700276.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700272,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10700276)
	e1:SetTarget(c10700276.thtg)
	e1:SetOperation(c10700276.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--reset  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700276,1))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_POSITION+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10700277)
	e3:SetCondition(c10700276.poscon)
	e3:SetTarget(c10700276.postg)
	e3:SetOperation(c10700276.posop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700276,1))
	e4:SetCategory(CATEGORY_COIN+CATEGORY_POSITION+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10700277)
	e4:SetCondition(c10700276.poscon2)
	e4:SetTarget(c10700276.postg2)
	e4:SetOperation(c10700276.posop2)
	c:RegisterEffect(e4) 
	--spsummon proc
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c10700276.spcon)
	c:RegisterEffect(e5)	 
end
c10700276.toss_coin=true
function c10700276.thfilter(c)
	return c:IsSetCard(0xf1a3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10700276.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700276.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700276.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700276.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10700276.cfilter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c10700276.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c10700276.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10700276.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) and not Duel.IsPlayerAffectedByEffect(tp,10701040)
end
function c10700276.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10700276.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10700276.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700276.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10700276.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c10700276.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	  local res=Duel.TossCoin(tp,1)
	  if res==1 then 
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			   if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(10700276,2)) then
				 Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			   end
			end
	  else 
			Duel.NegateRelatedChain(c,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetOwner())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			c:RegisterEffect(e3)
	  end
end
function c10700276.poscon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) and Duel.IsPlayerAffectedByEffect(tp,10701040)
end
function c10700276.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10700276.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700276.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10700276.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c10700276.posop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	  local c1,c2,c3=Duel.TossCoin(tp,3)
	  if c1+c2+c3>0 then 
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			   if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(10700276,2)) then
				 Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			   end
			end
	  else 
			Duel.NegateRelatedChain(c,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetOwner())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			c:RegisterEffect(e3)
	  end
end