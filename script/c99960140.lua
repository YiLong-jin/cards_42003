--真魔法·消歧义
local s,id,o=GetID()
dofile("expansions/script/c99960010.lua")
function s.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,99960140+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(shenqi_Savior.spellcost3)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
		if not shenqi_Savior.global_check then
		shenqi_Savior.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(shenqi_Savior.aclimit)
		Duel.RegisterEffect(ge1,0)
	end
end

s.Savior_shenqi=true

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetValue(s.elimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterEffect(e2,1-tp)
end
function s.elimit2(e,re,tp)
	local tc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and not (tc.Savior_shenqi or tc.Savior_mojie)
end
function s.elimit1(e,re,tp)
	local tc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not (tc.Savior_shenqi or tc.Savior_mojie)
end
