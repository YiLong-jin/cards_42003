--黑骑士小队-克拉
function c9877611.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877611)
	e3:SetCost(c9877611.cost1)
	e3:SetCondition(c9877611.spcon1)
	e3:SetTarget(c9877611.destg)
	e3:SetOperation(c9877611.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877611.spcon2)
	c:RegisterEffect(e4)
	
end
function c9877611.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877611.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877611.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)
	else Duel.PayLPCost(tp,500) end
end
function c9877611.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9877611.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler() 
	 local tc=Duel.GetFirstTarget()
	 if tc:IsRelateToEffect(e) and tc:IsAttackPos() and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 and Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(9877611,0)) then
		 Duel.PayLPCost(tp,500)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1) 
	end
end