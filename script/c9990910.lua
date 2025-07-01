--逐火之蛾 再度翱翔的休伯利安
function c9990910.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990910+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x669))
	e3:SetValue(1)
	c:RegisterEffect(e3)
 
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9990910,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	--e4:SetCode(EVENT_FREE_CHAIN)
	--e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(2,9990910)
	e4:SetCondition(c9990910.condition)
	e4:SetTarget(c9990910.target)
	e4:SetOperation(c9990910.activate)
	c:RegisterEffect(e4)
end
function c9990910.condition(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	return t and t:IsControler(tp) and t:IsSetCard(0x669)
end
function c9990910.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttackTarget()
	if chkc then return chkc==tg end
	if chk==0 then return Duel.GetAttacker():IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c9990910.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=Duel.GetAttacker():GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(math.ceil(atk))
		tc:RegisterEffect(e1)
	end
end