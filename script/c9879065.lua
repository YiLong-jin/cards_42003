--精灵意志
function c9879065.initial_effect(c)
   
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879065,1))
	e2:SetCategory(EFFECT_UPDATE_ATTACK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9879065+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9879065.drcon)
	e2:SetTarget(c9879065.atktg)
	e2:SetOperation(c9879065.atkop)
	c:RegisterEffect(e2)
end
function c9879065.filter(c)
	return c:IsFaceup() and c:IsLinkAbove(4)
end
function c9879065.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879065.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9879065.atkfilter(c)
	return c:IsFaceup()
end
function c9879065.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879065.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9879065.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9879065.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(9879065,3))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetValue(1000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e3)
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e11)
		tc=g:GetNext()
	end
end