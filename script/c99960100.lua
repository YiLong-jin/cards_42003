--巫女什么的，神的狗而已
local s,id,o=GetID()
dofile("expansions/script/c99960010.lua")
function s.initial_effect(c)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99960100+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.con)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	

end
s.Savior_shenqi=true
function s.confilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c.Savior_bolishenshe
end
function s.filter(c)
	return c.Savior_shenqi
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetOperation(s.setop2)
	Duel.RegisterEffect(e2,tp)
	
		--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99960100,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTarget(aux.TargetBoolFunction(s.filter))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetValue(99960100)
	Duel.RegisterEffect(e1,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	Duel.RegisterEffect(e3,tp)
end
function s.setop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,99960100)
		Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
end
