--扭曲信仰
function c10000150.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetCountLimit(1,10000150+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10000150.accon) 
	e1:SetOperation(c10000150.acop)
	c:RegisterEffect(e1)  
end
function c10000150.accon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp  
end 
function c10000150.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetCondition(c10000150.rccon) 
	e1:SetOperation(c10000150.rcop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(c10000150.rccon) 
	e1:SetOperation(c10000150.rcop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
	return c:IsSetCard(0xafe3) end)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end 
function c10000150.rcfil(c,tp) 
	return c:IsSummonPlayer(1-tp) and c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end 
function c10000150.rccon(e,tp,eg,ep,ev,re,r,rp)  
	local g=eg:Filter(c10000150.rcfil,nil,tp)
	return g:GetCount()>0  
end 
function c10000150.rcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=eg:Filter(c10000150.rcfil,nil,tp)
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_RACE) 
		e1:SetValue(RACE_MACHINE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end 

