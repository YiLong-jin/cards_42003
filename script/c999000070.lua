--破魔的EXS『圣光之珠』
local m=999000070
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCost(c999000070.cost)
	e1:SetCountLimit(1,9990070)
	e1:SetTarget(c999000070.thtg)
	e1:SetOperation(c999000070.operation)
	e1:SetCondition(c999000070.spcon1)
	c:RegisterEffect(e1)
	
		
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetTarget(c999000070.thtg1)
	e2:SetCountLimit(1,9990070)
	e2:SetOperation(c999000070.operation1)
	e2:SetCondition(c999000070.spcon2)
	c:RegisterEffect(e2)
	c999000070.flag0_effect=e1	
	c999000070.flag1_effect=e2
end

function c999000070.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000070.thfilter,tp,LOCATION_DECK,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end


function c999000070.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000160)==0
end

function c999000070.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,999000160)~=0
end

function c999000070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999000070.thfilter(c)
	return c:IsSetCard(0x677)
end

function c999000070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999000070.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.spfilter(c,e,tp)
	return c:IsCode(999000150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1
end

function c999000070.thfilter100(c)
	return c:IsType(TYPE_MONSTER)
end
function c999000070.thfilter200(c)
	return c:IsType(TYPE_SPELL)
end
function c999000070.thfilter300(c)
	return c:IsType(TYPE_TRAP)
end




function c999000070.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999000070.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,2,2,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000070.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000070.thfilter200,1,nil) then
	Duel.Recover(tp,1000,REASON_EFFECT)
	end
	if tg:IsExists(c999000070.thfilter300,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g3=Duel.SelectMatchingCard(tp,c999000070.filter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		local tc=g3:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		  if tc:IsType(TYPE_QUICKPLAY) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		  end
		  if tc:IsType(TYPE_TRAP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		 end
	end
	end
			Duel.RegisterFlagEffect(tp,999000070,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end

function c999000070.filter1(c)
	return c:IsSetCard(0x677) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() 
			and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function cm.filter(c)
	return c:IsAbleToDeck()
end


function c999000070.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999000070.thfilter,tp,LOCATION_DECK,0,nil)
	local tg=g:Select(tp,4,4,nil)
	Duel.ConfirmCards(tp,tg)
	Duel.ConfirmCards(1-tp,tg)
	if tg:IsExists(c999000070.thfilter100,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				 
	end
	end
	if tg:IsExists(c999000070.thfilter200,1,nil) then
	Duel.Recover(tp,1000,REASON_EFFECT)
	end
	if tg:IsExists(c999000070.thfilter300,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g3=Duel.SelectMatchingCard(tp,c999000070.filter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		local tc=g3:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		  if tc:IsType(TYPE_QUICKPLAY) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		  end
		  if tc:IsType(TYPE_TRAP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		 end
	end
	end
			Duel.RegisterFlagEffect(tp,999000070,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)	
end