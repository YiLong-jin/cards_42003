--昏溟的EXS『永世』
local m=999000080
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCost(c999000080.cost)
	e1:SetTarget(c999000080.thtg)
		e1:SetCountLimit(1,9990080)
	e1:SetOperation(c999000080.operation)
	e1:SetCondition(c999000080.spcon1)
	c:RegisterEffect(e1)
	
		
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetTarget(c999000080.thtg1)
		e2:SetCountLimit(1,9990080)
	e2:SetOperation(c999000080.operation1)
	e2:SetCondition(c999000080.spcon2)
	c:RegisterEffect(e2)
	c999000080.flag0_effect=e1	
	c999000080.flag1_effect=e2
end

function c999000080.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000080.thfilter,tp,LOCATION_DECK,0,7,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end



function c999000080.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000090)==0
end

function c999000080.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000090)~=0
end


function c999000080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999000080.thfilter(c)
	return c:IsSetCard(0x677)
end

function c999000080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000080.thfilter,tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.spfilter(c,e,tp)
	return c:IsCode(999000160) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
end


function c999000080.thfilter100(c)
	return c:IsType(TYPE_MONSTER)
end
function c999000080.thfilter200(c)
	return c:IsType(TYPE_SPELL)
end
function c999000080.thfilter300(c)
	return c:IsType(TYPE_TRAP)
end


function c999000080.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999000080.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,5,5,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000080.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000080.thfilter200,3,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c999000080.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
	if tg:IsExists(c999000080.thfilter300,3,nil) then
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c999000080.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,999000080,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(DOUBLE_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
	end
			Duel.RegisterFlagEffect(tp,999000080,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end

function c999000080.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,999000080)==0 or bit.band(r,REASON_EFFECT)==0 then return val end
	Duel.ResetFlagEffect(tp,999000080)
	return val*2
end

function cm.filter(c)
	if not c:IsAbleToHand() then return false end
	return c:IsSetCard(0x677)
end


function c999000080.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999000080.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,7,7,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000080.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000080.thfilter200,3,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c999000080.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
	if tg:IsExists(c999000080.thfilter300,3,nil) then
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c999000080.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,999000080,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.RegisterFlagEffect(tp,999000080,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end