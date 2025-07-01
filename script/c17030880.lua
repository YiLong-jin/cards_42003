--真实的狂信徒
function c17030880.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c17030880.spcon)
	e1:SetOperation(c17030880.spop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c17030880.acop)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c17030880.atkval)
	c:RegisterEffect(e5)
end
function c17030880.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST)
end
function c17030880.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsCanRemoveCounter(tp,1,0,0x1,9,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(17030880,1)) then
		Duel.RemoveCounter(tp,1,0,0x1,9,REASON_COST)
		--double
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetCondition(c17030880.damcon)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetCondition(c17030880.condition)
		e2:SetOperation(c17030880.operation)
		e2:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e2)
	else
		Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
	end
end
function c17030880.damcon(e)
	return e:GetHandler():GetFlagEffect(17030880)==0
end
function c17030880.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c17030880.atkval(e,c)
	return e:GetHandler():GetCounter(0x1)*300
end
function c17030880.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c17030880.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(17030880)>0 then return end
	e:GetHandler():RegisterFlagEffect(17030880,RESET_EVENT+RESETS_STANDARD,0,1)
end
