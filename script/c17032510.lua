--阶级统治
function c17032510.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c17032510.antarget)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c17032510.catg)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9097866,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c17032510.atkcon)
	e4:SetOperation(c17032510.atkop)
	c:RegisterEffect(e4)
	--negate attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c17032510.checkop)
	c:RegisterEffect(e5)
end
function c17032510.antarget(e,c)
	return c:IsRank(0)
end
function c17032510.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetFlagEffect(17032510)==0 
end
function c17032510.catg(e,c)
	local rk=0
	local loc1=0
	local loc2=0
	local tp=e:GetHandlerPlayer()
	if tp==Duel.GetTurnPlayer() then loc1=LOCATION_MZONE else loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c17032510.filter,tp,loc1,loc2,nil)
	if #g>0 then
		local tc=g:GetMinGroup(Card.GetRank):GetFirst()
		rk=tc:GetRank()
	end
	return c:GetRank()>rk
end
function c17032510.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsAttackable() then
		tc:RegisterFlagEffect(17032510,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c17032510.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	e:SetLabelObject(a)
	return a and d and a:IsRelateToBattle() and d:IsRelateToBattle() and a:IsType(TYPE_XYZ) and d:IsType(TYPE_XYZ)
end
function c17032510.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:GetRank()==d:GetRank() then return false end
	local ac=nil
	local ct=0
	if a:GetRank()>d:GetRank() then ac=d ct=a:GetRank()-d:GetRank() else ac=a ct=d:GetRank()-a:GetRank() end
	if ac:IsFaceup() and ac:IsRelateToBattle()then
		Duel.Hint(HINT_CARD,0,17032510)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e1)
	end
end
