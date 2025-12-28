--滑雪爱好者
function c65843151.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1,65843151)
	e0:SetCondition(c65843151.drcon)
	e0:SetOperation(c65843151.drop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c65843151.limcon)
	e1:SetOperation(c65843151.limop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c65843151.limop2)
	c:RegisterEffect(e2)	
end
function c65843151.rlcfilter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT) and c:IsSummonPlayer(tp)
end
function c65843151.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65843151.rlcfilter,1,nil,tp)
end
function c65843151.limfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c65843151.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65843151.limfilter,1,nil,tp)
end
function c65843151.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c65843151.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(65843151,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c65843151.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65843151.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(65843151)
	e:Reset()
end
function c65843151.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(65843151)~=0 then
		Duel.SetChainLimitTillChainEnd(c65843151.chainlm)
	end
end
function c65843151.chainlm(e,ep,tp)
	return ep==tp or e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c65843151.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65843151)
	Duel.Draw(tp,1,REASON_EFFECT)
end