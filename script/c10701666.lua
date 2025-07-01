--幻醒龙 断罪神
function c10701666.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701666,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10701666)
	e1:SetCondition(c10701666.spcon)
	e1:SetTarget(c10701666.sptg)
	e1:SetOperation(c10701666.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701666,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10701667)
	e2:SetTarget(c10701666.sttg)
	e2:SetOperation(c10701666.stop)
	c:RegisterEffect(e2)	
	--activate from hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701666,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7c0))
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--
	Duel.AddCustomActivityCounter(10701666,ACTIVITY_CHAIN,c10701666.chainfilter)
end
function c10701666.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return rc:IsCode(10701666) or not ((rc:IsType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
		or (rc:IsSetCard(0x7c0) or rc:IsCode(24857466)))
end
function c10701666.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(10701666,tp,ACTIVITY_CHAIN)>0
		or Duel.GetCustomActivityCount(10701666,1-tp,ACTIVITY_CHAIN)>0
end
function c10701666.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10701666.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c10701666.stfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function c10701666.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c10701666.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701666.stfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c10701666.stfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c10701666.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(10701666,3))
		e1:SetCondition(c10701666.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c10701666.actfilter(c)
	return (c:IsSetCard(0x7c0) or c:IsCode(24857466)) and c:IsFaceup()
end
function c10701666.actcon(e)
	local tp=e:GetHandlerPlayer()
	return not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
		and not Duel.IsExistingMatchingCard(c10701666.actfilter,tp,LOCATION_MZONE,0,1,nil)
end