--穿锁的EXS『商神杖』
local m=999000050
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCost(c999000050.cost)
	e1:SetTarget(c999000050.thtg)
		e1:SetCountLimit(1,9990050)
	e1:SetOperation(c999000050.operation)
	e1:SetCondition(c999000050.spcon1)
	c:RegisterEffect(e1)
	
		
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetTarget(c999000050.thtg)
		e2:SetCountLimit(1,9990050)
	e2:SetOperation(c999000050.operation1)
	e2:SetCondition(c999000050.spcon2)
	c:RegisterEffect(e2)
	c999000050.flag0_effect=e1	
	c999000050.flag1_effect=e2
end
function c999000050.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000140)==0
end

function c999000050.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000140)~=0
end

function c999000050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999000050.thfilter(c)
	return c:IsSetCard(0x677)
end

function c999000050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000050.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.spfilter(c,e,tp)
	return c:IsCode(999000130) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
end

function c999000050.thfilter100(c)
	return c:IsType(TYPE_MONSTER)
end
function c999000050.thfilter200(c)
	return c:IsType(TYPE_SPELL)
end
function c999000050.thfilter300(c)
	return c:IsType(TYPE_TRAP)
end


function c999000050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999000050.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,2,2,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000050.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000050.thfilter200,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c999000050.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
	end
	if tg:IsExists(c999000050.thfilter300,2,nil) then
		local g3=Duel.SelectMatchingCard(tp,c999000050.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g3)
		local tc=g3:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
			Duel.RegisterFlagEffect(tp,999000050,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end

function c999000050.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end

function cm.filter(c)
	if not c:IsAbleToGrave() then return false end
	return c:IsSetCard(0x677)
end


function c999000050.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999000050.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,4,4,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000050.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000050.thfilter200,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c999000050.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
	end
	if tg:IsExists(c999000050.thfilter300,2,nil) then
		local g3=Duel.SelectMatchingCard(tp,c999000050.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g3)
		local tc=g3:GetFirst()
		if tc then
				local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
			Duel.RegisterFlagEffect(tp,999000050,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end