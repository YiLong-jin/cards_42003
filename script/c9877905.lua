--十咎桃子 修女
function c9877905.initial_effect(c)
	aux.AddCodeList(c,9877896)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c9877905.atkfilter)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c9877905.spcon1)
	e3:SetTarget(c9877905.destg)
	e3:SetOperation(c9877905.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e4:SetCondition(c9877905.spcon2)
	e4:SetTarget(c9877905.destg1)
	e4:SetOperation(c9877905.desop1)
	c:RegisterEffect(e4)
end
function c9877905.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9878240)
end
function c9877905.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9878240)
end

function c9877905.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9877905.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler() 
	 local tc=Duel.GetFirstTarget()
	 if tc:IsRelateToEffect(e) and tc:IsAttackPos()then
		 if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
			 local e1=Effect.CreateEffect(c) 
			  e1:SetType(EFFECT_TYPE_SINGLE) 
			  e1:SetCode(EFFECT_UPDATE_ATTACK)  
			  e1:SetRange(LOCATION_MZONE) 
			  e1:SetValue(500) 
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			  c:RegisterEffect(e1)
		end
	 end
end


function c9877905.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9877905.desop1(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler() 
	 local tc=Duel.GetFirstTarget()
	 if tc:IsRelateToEffect(e) and tc:IsAttackPos() then
	   if tc:IsDefenseBelow(800) then
		 if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
			  Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=e1:Clone()
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					tc:RegisterEffect(e3)
				end
			 local e1=Effect.CreateEffect(c) 
			  e1:SetType(EFFECT_TYPE_SINGLE) 
			  e1:SetCode(EFFECT_UPDATE_ATTACK)  
			  e1:SetRange(LOCATION_MZONE) 
			  e1:SetValue(500) 
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			  c:RegisterEffect(e1)
		  end
	   else
		   if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
			  local e1=Effect.CreateEffect(c) 
			  e1:SetType(EFFECT_TYPE_SINGLE) 
			  e1:SetCode(EFFECT_UPDATE_ATTACK)  
			  e1:SetRange(LOCATION_MZONE) 
			  e1:SetValue(500) 
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			  c:RegisterEffect(e1)
		   end
		end
	 end
end

function c9877905.atkfilter(e,c)
	return c:IsDefensePos()
end