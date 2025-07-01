--交响曲·悼念公主的帕凡舞曲
function c69969253.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c69969253.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969253,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,69969253)
	e1:SetCondition(c69969253.thcon)
	e1:SetTarget(c69969253.thtg)
	e1:SetOperation(c69969253.thop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969253,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,69969242)
	e2:SetCost(c69969253.spcost)
	e2:SetCondition(c69969253.condition)
	e2:SetTarget(c69969253.sptg)
	e2:SetOperation(c69969253.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
--0
function c69969253.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x69b)
end
--1
function c69969253.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c69969253.thfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c69969253.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69969253.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69969253.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c69969253.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c69969253.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--2
function c69969253.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x69b) and c:IsFaceup()
end
function c69969253.condition(e,tp,eg,ep,ev,re,r,rp)
   if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c69969253.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev) 
end
function c69969253.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x69b) and (c:IsControler(tp) or c:IsFaceup())
end
function c69969253.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c69969253.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c69969253.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c69969253.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c69969253.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	if	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		Duel.NegateEffect(ev)
	end
	Duel.SpecialSummonComplete()
end
end