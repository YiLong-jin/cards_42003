--净化！净化！净化！
function c10000151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,10000151+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10000151.accon)
	e1:SetTarget(c10000151.actg) 
	e1:SetOperation(c10000151.acop)
	c:RegisterEffect(e1)  
	if not c10000151.global_check then
		c10000151.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c10000151.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c10000151.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsActiveType(TYPE_MONSTER) then 
		Duel.RegisterFlagEffect(rp,10000151,RESET_PHASE+PHASE_END,0,1)
		local rc=re:GetHandler()
		rc:RegisterFlagEffect(10000151,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
	end 
end 
function c10000151.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(1-tp,10000151)>=3   
end 
function c10000151.acfil(c) 
	return c:GetFlagEffect(10000151)~=0 and c:IsFaceup()
end 
function c10000151.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c10000151.acfil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetChainLimit(c10000151.chlimit)
end
function c10000151.chlimit(e,ep,tp)
	return tp==ep
end
function c10000151.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c10000151.acfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_RACE) 
		e1:SetValue(RACE_MACHINE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
		tc:RegisterEffect(e1) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)  
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
		tc:RegisterEffect(e1) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_TRIGGER)  
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)  
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end 





