--色孽爱言-剜心咒
function c21400044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,21400044+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c21400044.target)
	e1:SetOperation(c21400044.activate)
	c:RegisterEffect(e1)
end
function c21400044.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
end
function c21400044.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,1)
	local ab1=g1:CheckWithSumEqual(Card.GetLevel,6,1,99)  
	local xtable1={aux.Stringid(21400044,2)} 
	if ab1 then table.insert(xtable1,aux.Stringid(21400044,1)) end  
	local op1=Duel.SelectOption(tp,table.unpack(xtable1))+1 
	local g2=Duel.GetMatchingGroup(Card.IsLevelAbove,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,1)
	local ab2=g2:CheckWithSumEqual(Card.GetLevel,6,1,99)  
	local xtable2={aux.Stringid(21400044,2)} 
	if ab2 then table.insert(xtable2,aux.Stringid(21400044,1)) end 
	local op2=Duel.SelectOption(1-tp,table.unpack(xtable2))+1 
	if xtable1[op1]==aux.Stringid(21400044,1) then 
		local sg=g1:SelectWithSumEqual(tp,Card.GetLevel,6,1,99) 
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end 
	if xtable1[op1]==aux.Stringid(21400044,2) then  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_SUMMON_COST)
		e1:SetTargetRange(0xff,0) 
		e1:SetCost(c21400044.spcost)
		e1:SetOperation(c21400044.spcop) 
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_SPSUMMON_COST)
		e1:SetTargetRange(0xff,0) 
		e1:SetOperation(c21400044.spcop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)  
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST) 
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCost(c21400044.costchk)
		e2:SetOperation(c21400044.costop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_FLAG_EFFECT+21400044) 
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp) 
	end  
	if xtable2[op2]==aux.Stringid(21400044,1) then 
		local sg=g2:SelectWithSumEqual(1-tp,Card.GetLevel,6,1,99) 
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end 
	if xtable2[op2]==aux.Stringid(21400044,2) then  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_SUMMON_COST)
		e1:SetTargetRange(0xff,0) 
		e1:SetCost(c21400044.spcost)
		e1:SetOperation(c21400044.spcop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,1-tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_SPSUMMON_COST)
		e1:SetTargetRange(0xff,0) 
		e1:SetCost(c21400044.spcost)
		e1:SetOperation(c21400044.spcop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,1-tp)  
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST) 
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCost(c21400044.costchk)
		e2:SetOperation(c21400044.costop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,1-tp) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_FLAG_EFFECT+21400044) 
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,1-tp) 
	end  
end 
function c21400044.spcost(e,c,tp)
	return Duel.CheckLPCost(tp,800)
end
function c21400044.spcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end
function c21400044.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,21400044)
	return Duel.CheckLPCost(tp,ct*800)
end
function c21400044.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end

