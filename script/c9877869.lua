--银月鬼杀式神-青狼
function c9877869.initial_effect(c)
	aux.AddCodeList(c,9877864,9877870)  
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
	e1:SetCondition(c9877869.ckcon)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(-1500) 
	e1:SetCondition(c9877869.ckcon)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c9877869.ckcon)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9877869)
	e2:SetTarget(c9877869.destg)
	e2:SetOperation(c9877869.desop)
	c:RegisterEffect(e2)
end
function c9877869.ckfil(c) 
	return c:IsFaceup() and c:IsCode(9877864)  
end  
function c9877869.ckcon(e) 
	local tp=e:GetHandlerPlayer() 
	return not Duel.IsExistingMatchingCard(c9877869.ckfil,tp,LOCATION_MZONE,0,1,nil)   
end 
function c9877869.desfil(c) 
	return c:IsFaceup() and c:IsDisabled()  
end 
function c9877869.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9877869.desfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9877869.desfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9877869.setfilter(c)
	return c:IsCode(9877870) and c:IsSSetable()
end
function c9877869.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9877869.setfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877869,0)) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c9877869.setfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil):GetFirst() 
		if tc and Duel.SSet(tp,tc)~=0 then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1,true)
		end 
	end
end





