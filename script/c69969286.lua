--交响曲·火星
function c69969286.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c69969286.matfilter1,nil,nil,c69969286.matfilter2,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c69969286.poscon)
	e3:SetValue(c69969286.atkval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c69969286.poscon)
	e4:SetValue(c69969286.atkval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969286,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCountLimit(2,69969286)
	e5:SetCondition(c69969286.atcon)
	e5:SetCost(c69969286.atkcost)
	e5:SetOperation(c69969286.atop)
	c:RegisterEffect(e5)
end
function c69969286.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0x69b)
end
function c69969286.matfilter2(c,syncard)
	return c:IsNotTuner(syncard) and c:IsSetCard(0x69b)
end
--1
function c69969286.poscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c69969286.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER)
end
function c69969286.atkval(e,c)
	return Duel.GetMatchingGroupCount(c69969286.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-500
end
--2
function c69969286.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0)
end
function c69969286.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0x69b) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0x69b)
	Duel.Release(g,REASON_COST)
end
function c69969286.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end


