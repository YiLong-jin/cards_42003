--機骸級ハッキョクケン
function c10700935.initial_effect(c)
	aux.AddCodeList(c,10700900,10700905)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700935,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,10700935+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10700935.cost)
	e1:SetTarget(c10700935.target)
	e1:SetOperation(c10700935.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700930,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,10700936)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700935.thtg)
	e2:SetOperation(c10700935.thop)
	c:RegisterEffect(e2)	 
end
function c10700935.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c10700935.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND 
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700935.costfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c10700935.costfilter,tp,loc,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c10700935.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c10700935.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,10700935,0,0x21,1000,1000,4,RACE_MACHINE,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10700935.cfilter1(c)
	return c:IsFaceup() and c:IsCode(10700900)
end
function c10700935.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,10700935,0,0x21,1000,1000,4,RACE_MACHINE,ATTRIBUTE_FIRE) then return end
	c:AddMonsterAttribute(TYPE_NORMAL)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c10700935.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c10700935.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(10700935,2)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c10700935.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
			local atk=tc:GetBaseAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if c:IsFaceup() then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(atk)
				c:RegisterEffect(e2)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1,tp)
end
function c10700935.thfilter(c)
	return c:IsCode(10700905) and c:IsAbleToHand()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10700935.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c10700935.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700935.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700935.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	if Duel.IsExistingMatchingCard(c10700935.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetLabel(0)
	end
end
function c10700935.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	 Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end