--源世尺度
local m=33300150
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.target)
	e3:SetValue(cm.indct)
	c:RegisterEffect(e3)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetCondition(cm.rdcon)
   --e2:SetOperation(cm.rdop)
	--c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(cm.atkcon0)
	e2:SetOperation(cm.atkop0)
	c:RegisterEffect(e2)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(cm.atkcon)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
	--atk & def
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.atkcon1)
	e5:SetTarget(cm.atktg1)
	e5:SetOperation(cm.atkop1)
	c:RegisterEffect(e5)
end
function cm.target(e,c)
	return c:IsSetCard(0x560)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function cm.reftg(e,c)
	return c~=e:GetHandler() and c:IsFaceup()
end
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local a1=eg:GetFirst()
	local a2=eg:GetNext()
	return ep==tp and eg:GetFirst():GetControler()~=tp and eg:GetFirst():GetFlagEffect(m)>0
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
	Duel.Damage(1-tp,1-ev/2,REASON_EFFECT)
end
function cm.atkcon0(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if b==nil or a==nil then
	return false end
	if a:IsControler(1-tp) then
	   a=Duel.GetAttackTarget()
	end
	return a:IsSetCard(0x560)
end
function cm.atkop0(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	--local a=Duel.GetAttacker()
	--local b=Duel.GetAttackTarget()
	--a:RegisterFlagEffect(m,RESET_EVENT+EVENT_BATTLE_END,0,1,0)
	--b:RegisterFlagEffect(m,RESET_EVENT+EVENT_BATTLE_END,0,1,0)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	--local d=Duel.GetAttackTarget()
	--if chk==0 then return d~=nil and d:IsControler(tp) and d:IsSetCard(0x560) end
	if b==nil or a==nil then
	return false end
	if a:IsControler(1-tp) then 
		a=Duel.GetAttackTarget()
		b=Duel.GetAttacker()
	end
	local d=1
	if a:GetAttack()>b:GetAttack() then  
	   d=0
	end
	e:SetLabel(d)
	return a:IsSetCard(0x560)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ALSO_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local a=e:GetLabel()
	if a==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(HALF_DAMAGE)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
	--local a=Duel.GetAttacker()
	--local b=Duel.GetAttackTarget()
	--a:RegisterFlagEffect(m,RESET_EVENT+EVENT_BATTLE_END,0,1,0)
	--b:RegisterFlagEffect(m,RESET_EVENT+EVENT_BATTLE_END,0,1,0)
end
function cm.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
		and (Duel.GetAttacker():IsControler(tp) and Duel.GetAttacker():IsSetCard(0x560)
			or Duel.GetAttackTarget():IsControler(tp) and Duel.GetAttackTarget():IsSetCard(0x560))
end
function cm.cfilter(c)
	return c:IsSetCard(0x560) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local a=Duel.GetAttackTarget()
		local b=Duel.GetAttacker()
		if a and b and a:IsControler(1-tp) then a=Duel.GetAttacker() b=Duel.GetAttackTarget() end
		local atk=g:GetFirst():GetAttack()
		if atk==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		a:RegisterEffect(e1)
	end
end






