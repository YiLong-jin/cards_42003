--薇特莉斯甜点工坊-饼干蛋糕酱
function c9871035.initial_effect(c)
	c:SetUniqueOnField(1,0,9871035)
	
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9871035)
	e2:SetTarget(c9871035.target1)
	e2:SetOperation(c9871035.activate1)
	c:RegisterEffect(e2)
end
function c9871035.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x17e4) and c:IsType(TYPE_MONSTER)
end
function c9871035.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9871035.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c9871035.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9871035.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9871035,0)) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(9871035,1))
		e2:SetType(EFFECT_TYPE_SINGLE) 
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(1)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end