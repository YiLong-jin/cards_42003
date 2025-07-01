--PS歼灭
function c73116909.initial_effect(c)
	aux.AddXyzProcedure(c,c73116909.mfilter,9,3)
	c:EnableReviveLimit()
	----------------------------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73116909,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,73116909)
	e1:SetCondition(c73116909.rmcon)
	e1:SetTarget(c73116909.rmtg)
	e1:SetOperation(c73116909.rmop)
	c:RegisterEffect(e1)
	----------------------------------------------------------------------------------------------------------------------------------------
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73116909,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c73116909.thcon)
	e2:SetTarget(c73116909.thtg)
	e2:SetOperation(c73116909.thop)
	c:RegisterEffect(e2)
	----------------------------------------------------------------------------------------------------------------------------------------
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73116909,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c73116909.discon)
	e3:SetTarget(c73116909.distg)
	e3:SetOperation(c73116909.disop)
	c:RegisterEffect(e3)
	----------------------------------------------------------------------------------------------------------------------------------------
	local e4=Effect.CreateEffect(c)
	-- e4:SetDescription(aux.Stringid(5230799,3)) //修正描述参数
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x8ac))
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetValue(73116909)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e5)
end
	----------------------------------------------------------------------------------------------------------------------------------------
function c73116909.mfilter(c)
	return c:IsSetCard(0x7ac)
end
function c73116909.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c73116909.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	if (not Duel.IsPlayerAffectedByEffect(tp, 59822133) and Duel.GetMZoneCount(tp, g) >= 4) then
		for i=73116951,73116954 do
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,i,0x7ac,TYPES_TOKEN_MONSTER,3000,2500,8,RACE_PSYCHO,ATTRIBUTE_DARK,POS_FACEUP) then
				return
			end
		end
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
	end
end
function c73116909.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>3 then
		for i=73116951,73116954 do
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,i,0,TYPES_TOKEN_MONSTER,3000,2500,8,RACE_PSYCHO,ATTRIBUTE_DARK,POS_FACEUP) then
				return
			end
		end
		if not Duel.SelectYesNo(tp, aux.Stringid(73116909,4)) then return end
		Duel.BreakEffect()
		for i=1,4 do
			local token=Duel.CreateToken(tp,73116950+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e2:SetValue(c73116909.fuslimit)
			token:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c73116909.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c73116909.cfilter(c)
	return c:IsFaceup() and c:IsCode(73116951)
end
function c73116909.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(c73116909.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c73116909.thfilter(c)
	return c:IsSetCard(0x8ac) and c:IsAbleToHand() 
end
function c73116909.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116909.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and (Duel.GetFlagEffect(tp,73116909)==0 or Duel.GetFlagEffect(tp,73116909)==2) end
	Duel.RegisterFlagEffect(tp,73116909,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c73116909.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c73116909.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c73116909.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x8ac)
end
function c73116909.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and (Duel.GetFlagEffect(tp,73116909)==0 or Duel.GetFlagEffect(tp,73116909)==1) end
	Duel.RegisterFlagEffect(tp,73116909,RESET_PHASE+PHASE_END,0,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c73116909.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end