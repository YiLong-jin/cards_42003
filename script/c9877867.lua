--银月鬼杀式神-炎狐
function c9877867.initial_effect(c)
	aux.AddCodeList(c,9877864) 
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) end)
	c:RegisterEffect(e1) 
	--atk 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(-1500) 
	e1:SetCondition(c9877867.ckcon)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(-1500) 
	e1:SetCondition(c9877867.ckcon)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c9877867.ckcon)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9877867) 
	e2:SetTarget(c9877867.settg)
	e2:SetOperation(c9877867.setop)
	c:RegisterEffect(e2)
end 
function c9877867.ckfil(c) 
	return c:IsFaceup() and c:IsCode(9877864)  
end  
function c9877867.ckcon(e) 
	local tp=e:GetHandlerPlayer() 
	return not Duel.IsExistingMatchingCard(c9877867.ckfil,tp,LOCATION_MZONE,0,1,nil)   
end 
function c9877867.setfilter(c)
	return aux.IsCodeListed(c,9877864) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9877867.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877867.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c9877867.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c9877867.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.SelectYesNo(tp,aux.Stringid(9877867,0)) then   
			Duel.BreakEffect()
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP) 
			Duel.Destroy(dg,REASON_EFFECT)  
		end 
	end
end



