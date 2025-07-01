--驱动女神@绀紫之心
function c71100283.initial_effect(c)
	c:SetUniqueOnField(1,0,71100283)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetTarget(c71100283.sptg)
	e1:SetOperation(c71100283.spop)
	e1:SetCost(c71100283.spcost)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100283,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetLabel(3500)
	e2:SetCondition(c71100283.condition)
	e2:SetTarget(c71100283.sttg)
	e2:SetOperation(c71100283.stop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71100283,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetLabel(3500)
	e3:SetCondition(c71100283.condition)
	e3:SetTarget(c71100283.rmtg)
	e3:SetOperation(c71100283.rmop)
	--c:RegisterEffect(e3)
end
function c71100283.cpufilter(c,e)
	local tp=e:GetOwnerPlayer()
	return c:IsCode(71100278) and c:IsAttackAbove(2500) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end
function c71100283.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.CheckReleaseGroup(tp,c71100283.cpufilter,1,nil,e) end
	local sg=Duel.SelectReleaseGroup(tp,c71100283.cpufilter,1,1,nil,e)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	Duel.Release(sg,REASON_COST)
end
function c71100283.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71100283.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100283.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(e:GetLabel())
end
function c71100283.filter2(c)
	  return c:IsSetCard(0x17df) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable() 
end
function c71100283.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71100283.filter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c71100283.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c71100283.filter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		  if tc:IsType(TYPE_QUICKPLAY) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		  end
	end
end
function c71100283.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c71100283.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end