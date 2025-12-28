--圣杯媒体人 22
function c65843152.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTarget(c65843152.distg)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65843152.cost)
	e1:SetTarget(c65843152.pztg)
	e1:SetOperation(c65843152.pzop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65843152.damcon1)
	e2:SetOperation(c65843152.damop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65843152.regcon)
	e3:SetOperation(c65843152.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c65843152.damcon2)
	e4:SetOperation(c65843152.damop2)
	c:RegisterEffect(e4)
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(aux.ritlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_REMOVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c65843152.pencon)
	e6:SetTarget(c65843152.pentg)
	e6:SetOperation(c65843152.penop)
	c:RegisterEffect(e6)
end
function c65843152.cfilter(c)
	return c:GetOriginalType()&TYPE_EFFECT==0 and c:IsAbleToRemoveAsCost()
end
function c65843152.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65843152.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65843152.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65843152.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c65843152.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,8,"Greater")
		local bool=mg:CheckSubGroup(Auxiliary.RitualCheck,1,99,tp,c,8,"Greater")
		Auxiliary.GCheckAdditional=nil
		return bool
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_PZONE)
end
function c65843152.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,8,"Greater")
	local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,true,1,99,tp,c,8,"Greater")
	Auxiliary.GCheckAdditional=nil
	if mat and mat:GetCount()>0 then
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c65843152.filter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsType(TYPE_EFFECT)
end
function c65843152.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65843152.filter,1,nil,1-tp)
		and not Duel.IsChainSolving()
end
function c65843152.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65843152)
	Duel.Damage(1-tp,300,REASON_EFFECT)
	Duel.Recover(tp,300,REASON_EFFECT)
end
function c65843152.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65843152.filter,1,nil,1-tp)
		and Duel.IsChainSolving()
end
function c65843152.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(65843152,RESET_CHAIN,0,1)
end
function c65843152.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(65843152)>0
end
function c65843152.damop2(e,tp,eg,ep,ev,re,r,rp)
	local n=e:GetHandler():GetFlagEffect(65843152)
	e:GetHandler():ResetFlagEffect(65843152)
	Duel.Hint(HINT_CARD,0,65843152)
	Duel.Damage(1-tp,n*300,REASON_EFFECT)
	Duel.Recover(tp,n*300,REASON_EFFECT)
end
function c65843152.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_PZONE) and c:IsFaceup()
end
function c65843152.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c65843152.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end