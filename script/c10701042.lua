--奇术师 复活节-A-
function c10701042.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10701042)
	e1:SetCondition(c10701042.spcon)
	e1:SetTarget(c10701042.sptg)
	e1:SetOperation(c10701042.spop)
	c:RegisterEffect(e1)  
	--reset  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700276,1))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_TOHAND+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10701043)
	e3:SetCondition(c10701042.thcon)
	e3:SetTarget(c10701042.thtg)
	e3:SetOperation(c10701042.thop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700276,1))
	e4:SetCategory(CATEGORY_COIN+CATEGORY_TOHAND+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10701043)
	e4:SetCondition(c10701042.thcon2)
	e4:SetTarget(c10701042.thtg2)
	e4:SetOperation(c10701042.thop2)
	c:RegisterEffect(e4)   
end
c10701042.toss_coin=true
function c10701042.cfilter(c)
	return c.toss_coin
end
function c10701042.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10701042.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10701042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701042.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c10701042.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) and not Duel.IsPlayerAffectedByEffect(tp,10701040)
end
function c10701042.thfilter(c)
	return c:IsSetCard(0xf1a3) and c:IsAbleToHand()
end
function c10701042.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701042.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701042.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10701042.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c10701042.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	  local res=Duel.TossCoin(tp,1)
	  if res==1 then 
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
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
function c10701042.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) and Duel.IsPlayerAffectedByEffect(tp,10701040)
end
function c10701042.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701042.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701042.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10701042.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c10701042.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	  local c1,c2,c3=Duel.TossCoin(tp,3)
	  if c1+c2+c3>0 then 
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
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