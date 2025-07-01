--驱动女神@翡绿之心
function c71100281.initial_effect(c)
	c:SetUniqueOnField(1,0,71100281)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetTarget(c71100281.sptg)
	e1:SetOperation(c71100281.spop)
	e1:SetCost(c71100281.spcost)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100281,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e2:SetLabel(3500)
	e2:SetCountLimit(1)
	e2:SetCondition(c71100281.condition)
	e2:SetTarget(c71100281.tgtg)
	e2:SetOperation(c71100281.tgop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71100281,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetDescription(aux.Stringid(71100281,1))
	e3:SetLabel(3500)
	e3:SetValue(1)
	e3:SetCondition(c71100281.condition)
	--c:RegisterEffect(e3)
 --damage val
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	e4:SetLabel(3500)
	e4:SetCondition(c71100281.condition)
	--c:RegisterEffect(e4)
end
function c71100281.cpufilter(c,e)
	local tp=e:GetOwnerPlayer()
	return c:IsCode(71100276) and c:IsAttackAbove(2500) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0
end
function c71100281.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.CheckReleaseGroup(tp,c71100281.cpufilter,1,nil,e) end
	local sg=Duel.SelectReleaseGroup(tp,c71100281.cpufilter,1,1,nil,e)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	Duel.Release(sg,REASON_COST)
end
function c71100281.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71100281.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100281.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(e:GetLabel())
end
function c71100281.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetTurnPlayer()~=tp end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c71100281.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
