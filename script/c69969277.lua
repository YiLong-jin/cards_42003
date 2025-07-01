--交响曲·闲聊快速波尔卡
function c69969277.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x69b),c69969277.mfilter,1,true,true)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969277,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,69969277)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c69969277.cost)
	e2:SetTarget(c69969277.sptg)
	e2:SetOperation(c69969277.spop)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969277,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,69969264)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c69969277.spcon2)
	e3:SetTarget(c69969277.sptg2)
	e3:SetOperation(c69969277.spop2)
	c:RegisterEffect(e3)


end
function c69969277.mfilter(c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsFusionType(TYPE_EFFECT) and c:IsLocation(LOCATION_MZONE)
end
--1
function c69969277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c69969277.retop)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(69969277,RESET_EVENT+RESETS_STANDARD,0,0)
		e:SetLabelObject(c)
	end
end
function c69969277.retop(e,tp,eg,ep,ev,re,r,rp)
 if e:GetHandler():GetFlagEffect(69969277)~=0 then
	Duel.ReturnToField(e:GetLabelObject())
end
end
function c69969277.srfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevel(6,7)
end
function c69969277.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969277.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69969277.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969277.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--2
function c69969277.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c69969277.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ec,1,0,0)
end
function c69969277.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and ec then
			Duel.BreakEffect()
			Duel.SendtoHand(ec,nil,REASON_EFFECT)
	end
end