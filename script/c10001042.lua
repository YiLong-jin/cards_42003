--环指人体派大师之作 闭馆-装置艺术第1号"各位四散的肉与骨将化为观众席"
local s,id,o=GetID()
local SET_HZ=0x7fe0
function s.initial_effect(c)

	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE)
	e0b:SetCode(EFFECT_CANNOT_DISABLE)
	e0b:SetCondition(s.fivecon)
	c:RegisterEffect(e0b)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.hzfilter(c)
	return c:IsSetCard(SET_HZ) and c:IsType(TYPE_MONSTER)
end
function s.fivecon(e)
	return Duel.GetMatchingGroupCount(s.hzfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)>=5
end
function s.monfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.monfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(s.monfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	if dg:GetCount()>0 then
		local ct=Duel.Destroy(dg,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(1-tp,ct*800,REASON_EFFECT)
		end
	end

	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atkfilter)
	e1:SetValue(500)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function s.atkfilter(e,c)
	return c:IsSetCard(SET_HZ) and c:IsType(TYPE_MONSTER)
end