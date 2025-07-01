--暗之书原典 魔神转生录
function c99960200.initial_effect(c)
		--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e9)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c99960200.aclimit)
	c:RegisterEffect(e1)
end
function c99960200.aclimit(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and tc.Savior_mojie then
	Duel.Hint(HINT_CARD,1-tp,99960200)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(24,0,aux.Stringid(99960010,6))
	end
end