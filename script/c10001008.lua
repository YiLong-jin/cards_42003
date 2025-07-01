--红翅尖粉蝶
function c10001008.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10001008,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,20001008)
	e1:SetTarget(c10001008.lvtg)
	e1:SetOperation(c10001008.lvop)
	c:RegisterEffect(e1)
end
function c10001008.lvfilter(c)
	return not c:IsLevel(3) and c:IsFaceup() and c:IsLevelAbove(1)
end
function c10001008.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10001008.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10001008.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10001008.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(3)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end