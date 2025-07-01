--驱动女神@群白之心
function c71100282.initial_effect(c)
	  c:SetUniqueOnField(1,0,71100282)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetTarget(c71100282.sptg)
	e1:SetOperation(c71100282.spop)
	e1:SetCost(c71100282.spcost)
	c:RegisterEffect(e1)
   --tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100282,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e2:SetLabel(2500)
	e2:SetCountLimit(1)
	e2:SetCondition(c71100282.condition)
	e2:SetTarget(c71100282.postg)
	e2:SetOperation(c71100282.posop)
	--c:RegisterEffect(e2)
	 --attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetLabel(3500)
	e3:SetCondition(c71100282.condition)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x17df))
	c:RegisterEffect(e3)
end
function c71100282.cpufilter(c,e)
	local tp=e:GetOwnerPlayer()
	return c:IsCode(71100277) and c:IsAttackAbove(2500) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end
function c71100282.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.CheckReleaseGroup(tp,c71100282.cpufilter,1,nil,e) end
	local sg=Duel.SelectReleaseGroup(tp,c71100282.cpufilter,1,1,nil,e)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	Duel.Release(sg,REASON_COST)
end
function c71100282.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71100282.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100282.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(e:GetLabel())
end
function c71100282.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c71100282.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100282.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c71100282.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c71100282.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71100282.filter,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
