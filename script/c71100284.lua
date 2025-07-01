--驱动女神@圣黑之心
function c71100284.initial_effect(c)
		c:SetUniqueOnField(1,0,71100284)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetTarget(c71100284.sptg)
	e1:SetOperation(c71100284.spop)
	e1:SetCost(c71100284.spcost)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c71100284.condition)
	e2:SetLabel(2500)
	c:RegisterEffect(e2)
	--int
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetLabel(3500)
	e3:SetCondition(c71100284.condition)
	e3:SetTarget(c71100284.indtg)
	e3:SetValue(c71100284.indesval)
	c:RegisterEffect(e3)
end
function c71100284.cpufilter(c,e)
	local tp=e:GetOwnerPlayer()
	return c:IsCode(71100279) and c:IsAttackAbove(2500) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end
function c71100284.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.CheckReleaseGroup(tp,c71100284.cpufilter,1,nil,e) end
	local sg=Duel.SelectReleaseGroup(tp,c71100284.cpufilter,1,1,nil,e)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	Duel.Release(sg,REASON_COST)
end
function c71100284.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71100284.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100284.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(e:GetLabel())
end
function c71100284.indtg(e,c)
	return c~=e:GetHandler()
end
function c71100284.indesval(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end