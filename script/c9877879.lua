--映于镜中的虚张笑容
function c9877879.initial_effect(c)
	aux.AddCodeList(c,9877873,9877877)

	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)   
	c:RegisterEffect(e0) 

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)  
	e1:SetCountLimit(1,9877879+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c9877879.condition) 
	e1:SetTarget(c9877879.target)
	e1:SetOperation(c9877879.operation)
	c:RegisterEffect(e1)
	
end
function c9877879.acfil(c)
	return c:IsFaceup()
end
function c9877879.filter(c)
	return aux.IsCodeListed(c,9877877) and c:IsFaceup()
end
function c9877879.filter2(c)
	return c:IsFaceup() and c:IsCode(9877873)
end
function c9877879.atkfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9877877)
end
function c9877879.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9877879.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c9877879.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c9877879.acfil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,c9877879.acfil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1) 
end
function c9877879.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.IsExistingMatchingCard(c9877879.filter2,tp,LOCATION_MZONE,0,1,nil) then
	  if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
   else
	local x=Duel.TossCoin(tp,1)
	if x==1 then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	else
		 local g2=Duel.GetMatchingGroup(c9877879.atkfilter,tp,LOCATION_MZONE,0,nil)
		 local bc=g2:GetFirst()
			while bc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(9877879,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(200)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			bc:RegisterEffect(e3)
			local e13=Effect.CreateEffect(e:GetHandler())
			e13:SetDescription(aux.Stringid(9877879,3))
			e13:SetType(EFFECT_TYPE_SINGLE)
			e13:SetCode(EFFECT_UPDATE_DEFENSE)
			e13:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e13:SetValue(200)
			e13:SetReset(RESET_EVENT+RESETS_STANDARD)
			bc:RegisterEffect(e13)
			bc=g2:GetNext()
		  end
	end
  end
end