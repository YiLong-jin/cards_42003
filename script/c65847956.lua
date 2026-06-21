--镜魔 6
function c65847956.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetOperation(c65847956.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c65847956.handcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,65847956)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c65847956.sptg)
	e3:SetOperation(c65847956.spop)
	c:RegisterEffect(e3)
end
function c65847956.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e6) and c:IsLinkAbove(3)
end
function c65847956.handcon(e)
	return Duel.IsExistingMatchingCard(c65847956.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c65847956.activate(e,tp,eg,ep,ev,re,r,rp)
	--[[if Duel.GetTurnPlayer()==tp then
		Duel.RegisterFlagEffect(tp,65847950,RESET_PHASE+PHASE_END+RESET_SELF_TURN,1,2)
	else]]
		Duel.RegisterFlagEffect(tp,65847950,RESET_PHASE+PHASE_END,1,1)
	--end
end
function c65847956.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65847956.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65847956.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65847956.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65847956.spfilter(c,e,tp)
	return c:IsSetCard(0x3e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end