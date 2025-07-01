--机骸式居合术
function c10700945.initial_effect(c)
	aux.AddCodeList(c,10700925,10700920)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700945,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10700945.condition)
	e1:SetTarget(c10700945.target)
	e1:SetOperation(c10700945.atkop)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700945,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c10700945.condition2)
	e2:SetTarget(c10700945.target)
	e2:SetOperation(c10700945.defop)
	c:RegisterEffect(e2) 
	--cost
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700945,2))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c10700945.condition)
	e4:SetCost(c10700945.cost)
	e4:SetTarget(c10700945.target2)
	e4:SetOperation(c10700945.atkop)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700945,3))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(c10700945.condition2)
	e5:SetCost(c10700945.cost)
	e5:SetTarget(c10700945.target2)
	e5:SetOperation(c10700945.defop)
	c:RegisterEffect(e5) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700930,4))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,10700936)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10700945.thtg)
	e3:SetOperation(c10700945.thop)
	c:RegisterEffect(e3)	
end
function c10700945.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<PHASE_MAIN2 
end
function c10700945.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7cd)
end
function c10700945.filter1(c)
	return c:IsFaceup() 
end
function c10700945.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c10700945.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND 
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700945.costfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c10700945.costfilter,tp,loc,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c10700945.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10700945.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700945.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10700945.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.IsExistingMatchingCard(c10700945.lmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c10700945.chainlm)
	end
end
function c10700945.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10700945.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700945.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10700945.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.IsExistingMatchingCard(c10700945.lmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c10700945.chainlm)
	end
end
function c10700945.lmfilter(c)
	return c:IsFaceup() and c:IsCode(10700920)
end
function c10700945.chainlm(e,rp,tp)
	return tp==rp
end
function c10700945.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(c10700945.disop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c10700945.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10700945.defop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c10700945.disop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(c10700945.atklimit)
		e2:SetLabel(tc:GetRealFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		tc:RegisterFlagEffect(10700945,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,0)
	end
end
function c10700945.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
function c10700945.thfilter(c)
	return c:IsCode(10700925) and c:IsAbleToHand()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10700945.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c10700945.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700945.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700945.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	if Duel.IsExistingMatchingCard(c10700945.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetLabel(0)
	end
end
function c10700945.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	 Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c10700945.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		local rc=re:GetHandler()
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev,true) then
			   Duel.Destroy(rc,REASON_EFFECT)
			end
		end
	end
end