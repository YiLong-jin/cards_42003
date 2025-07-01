--六翼 罗瑜斌
function c9990240.initial_effect(c)
   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x671),3,true)
--  local e2=Effect.CreateEffect(c)
--  e2:SetType(EFFECT_TYPE_SINGLE)
--  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--  e2:SetCode(EFFECT_SPSUMMON_CONDITION)
--  e2:SetValue(c9990240.splimit)
--  c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c9990240.val)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9990240.immval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetTarget(c9990240.indtg)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c9990240.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x671) and se:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) or se:GetHandler():IsCode(9990240)
end
function c9990240.val(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)*-100
end
function c9990240.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
		and te:GetOwner():GetAttack()<=1000 and te:GetOwner():GetBaseAttack()>=0
end
function c9990240.indtg(e,c)
	return c~=e:GetHandler()
end