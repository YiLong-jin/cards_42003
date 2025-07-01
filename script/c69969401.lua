--狩魂使×镰刀
function c69969401.initial_effect(c)
	c:SetSPSummonOnce(69969401)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,c69969401.ovfilter,aux.Stringid(69969401,0))
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969401,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c69969401.thcost)
	e2:SetTarget(c69969401.thtg)
	e2:SetOperation(c69969401.thop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(69969401,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c69969401.condition)
	e1:SetCost(c69969401.cost)
	e1:SetOperation(c69969401.operation)
	c:RegisterEffect(e1)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969401,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,69969401)
	e4:SetTarget(c69969401.sptg)
	e4:SetOperation(c69969401.spop)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969401,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,69969401)
	e5:SetTarget(c69969401.sptg)
	e5:SetOperation(c69969401.spop)
	c:RegisterEffect(e5)	
	end
--0
function c69969401.ovfilter(c)
	return c:IsFaceup() and c:IsCode(69969400)
end
--1
function c69969401.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69969401.thfilter(c)
	return c:IsSetCard(0x69d) and c:IsAbleToHand()
end
function c69969401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969401.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69969401.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969401.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--2
function c69969401.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return ph==PHASE_DAMAGE and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and not Duel.IsDamageCalculated()
end
function c69969401.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(69969401)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local ct=c:RemoveOverlayCard(tp,1,75,REASON_COST)
	e:SetLabel(ct*1000)
	c:RegisterFlagEffect(69969401,RESET_PHASE+PHASE_DAMAGE,0,1)
		
end
function c69969401.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(rg)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
--3
function c69969401.filter(c,e,tp)
	return c:IsSetCard(0x69d) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c69969401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969401.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69969401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69969401.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		 if tc then
		 tc:SetMaterial(nil)
		 if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		 tc:CompleteProcedure()
		 if c:IsRelateToEffect(e) and #g2>0 and tc:IsLocation(LOCATION_MZONE) then
		 Duel.Overlay(tc,g2) 
		 local c=e:GetHandler()
		 if c:IsExtraDeckMonster() then
		   Duel.BreakEffect()
		   Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
end
end
end