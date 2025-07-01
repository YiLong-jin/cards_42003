--隶约的FLS『限制』
local m=999000040
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCost(c999000040.cost)
	e1:SetTarget(c999000040.thtg)
		e1:SetCountLimit(1,9990040)
	e1:SetOperation(c999000040.operation)
	e1:SetCondition(c999000040.spcon1)
	c:RegisterEffect(e1)
	
		
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetTarget(c999000040.thtg1)
		e2:SetCountLimit(1,9990040)
	e2:SetOperation(c999000040.operation1)
	e2:SetCondition(c999000040.spcon2)
	c:RegisterEffect(e2)
	c999000040.flag0_effect=e1	
	c999000040.flag1_effect=e2
end
function c999000040.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000130)==0
end

function c999000040.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000130)~=0
end


function c999000040.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000040.thfilter,tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end


function c999000040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999000040.thfilter(c)
	return c:IsSetCard(0x677)
end

function c999000040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000040.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.spfilter(c,e,tp)
	return c:IsCode(999000120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
end

function c999000040.thfilter100(c)
	return c:IsType(TYPE_MONSTER)
end
function c999000040.thfilter200(c)
	return c:IsType(TYPE_SPELL)
end
function c999000040.thfilter300(c)
	return c:IsType(TYPE_TRAP)
end


function c999000040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999000040.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,3,3,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000040.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000040.thfilter200,2,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9991130,2))
	local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
	end
	if tg:IsExists(c999000040.thfilter300,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g3=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
		Duel.HintSelection(g3)
		local tc1=g3:GetFirst()
		Duel.NegateRelatedChain(tc1,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e2)
	end
			Duel.RegisterFlagEffect(tp,999000040,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end

function cm.filter(c)
	if not c:IsAbleToGrave() then return false end
	return c:IsSetCard(0x677)
end


function c999000040.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999000040.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,5,5,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000040.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000040.thfilter200,2,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9991130,2))
	local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
	end
	if tg:IsExists(c999000040.thfilter300,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g3=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
		Duel.HintSelection(g3)
		local tc1=g3:GetFirst()
		Duel.NegateRelatedChain(tc1,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e2)
	end
			Duel.RegisterFlagEffect(tp,999000040,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end