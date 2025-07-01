--逐火之蛾的激斗
function c9990120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990120+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9990120.target)
	e1:SetOperation(c9990120.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9990120.handcon)
	c:RegisterEffect(e2)
end
function c9990120.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x669)
end
function c9990120.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990120.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9990120.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9990120.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9990120.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()*2
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetCondition(c9990120.actcon)
		e1:SetValue(c9990120.aclimit)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(atk)
		tc:RegisterEffect(e3)
	end
end
function c9990120.actcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c9990120.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c9990120.cfilter(c)
	return c:IsFaceup() and c:IsCode(9991110) 
end
function c9990120.handcon(e)
	return Duel.GetMatchingGroupCount(c9990120.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end