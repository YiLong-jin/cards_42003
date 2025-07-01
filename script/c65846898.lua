--超可爱执行者·烈火女
function c65846898.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,65846898+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65846898.spcon)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c65846898.atkcon)
	e2:SetTarget(c65846898.atktg)
	e2:SetValue(700)
	c:RegisterEffect(e2)
end
c65846898.SetCard_ZJ_CKAZXZ=true
function c65846898.filter(c)
	return c:IsAttackAbove(1700) and c:IsFaceup()
end
function c65846898.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846898.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c65846898.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c65846898.atktg(e,c)
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end