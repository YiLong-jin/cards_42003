--疾驱的EXS『神速之星』
local m=999000020
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCost(c999000020.cost)
	e1:SetTarget(c999000020.thtg)
		e1:SetCountLimit(1,9990020)
	e1:SetOperation(c999000020.operation)
	e1:SetCondition(c999000020.spcon1)
	c:RegisterEffect(e1)
	
		
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
		e2:SetCountLimit(1,9990020)
	e2:SetTarget(c999000020.thtg1)
	e2:SetOperation(c999000020.operation1)
	e2:SetCondition(c999000020.spcon2)
	c:RegisterEffect(e2)
	c999000020.flag0_effect=e1	
	c999000020.flag1_effect=e2
end

function c999000020.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000020.thfilter,tp,LOCATION_DECK,0,6,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c999000020.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000110)==0
end

function c999000020.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000110)~=0
end
function c999000020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999000020.thfilter(c)
	return c:IsSetCard(0x677)
end

function c999000020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000020.thfilter,tp,LOCATION_DECK,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.spfilter(c,e,tp)
	return c:IsCode(999000100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
end
function c999000020.thfilter100(c)
	return c:IsType(TYPE_MONSTER)
end
function c999000020.thfilter200(c)
	return c:IsType(TYPE_SPELL)
end
function c999000020.thfilter300(c)
	return c:IsType(TYPE_TRAP)
end



function c999000020.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999000020.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,4,4,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000020.thfilter100,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000020.thfilter200,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
	end
	if tg:IsExists(c999000020.thfilter300,2,nil) then
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			Duel.Destroy(sg1,REASON_EFFECT)
end
		Duel.RegisterFlagEffect(tp,999000020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end

function cm.filter(c)
	if not c:IsAbleToHand() then return false end
	return c:IsSetCard(0x677)
end


function c999000020.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999000020.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,6,6,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000020.thfilter100,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000020.thfilter200,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
	end
	if tg:IsExists(c999000020.thfilter300,2,nil) then
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			Duel.Destroy(sg1,REASON_EFFECT)
end
		Duel.RegisterFlagEffect(tp,999000020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end