--暗金教水晶侍女
function c2222708.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c2222708.efilter)
	e1:SetCondition(c2222708.dscon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e2:SetTargetRange(POS_FACEUP_ATTACK,0)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c2222708.spcon)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c2222708.atkcon)
	e3:SetValue(c2222708.atkval)
	c:RegisterEffect(e3)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	e6:SetCondition(c2222708.sfilter)
	c:RegisterEffect(e6)
end

function c2222708.sfilter(e,te)
	local tp=e:GetOwnerPlayer()
	return Duel.GetFlagEffect(tp,2222708)>=4
end
function c2222708.atkcon(e)
	local tp=e:GetOwnerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil and Duel.GetFlagEffect(tp,2222708)>=3
end
function c2222708.atkval(e,c)
	return math.ceil(Duel.GetAttackTarget():GetAttack()/2)
end
function c2222708.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c2222708.spcon(e,c)
	local tp=e:GetOwnerPlayer()
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,2222708)>=2
end
function c2222708.dscon(e)
local tp=e:GetOwnerPlayer()
	return Duel.GetFlagEffect(tp,2222708)>=1
end
