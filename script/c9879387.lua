--星辰偶像-翼龙
function c9879387.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c9879387.synfilter1),1)
	c:EnableReviveLimit()
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(c9879387.atk)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)  
	
	
	local e11=Effect.CreateEffect(c) 
	e11:SetCategory(CATEGORY_DISABLE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)  
	e11:SetCountLimit(1,9879387) 
	e11:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=3 end)
	e11:SetTarget(c9879387.target)
	e11:SetOperation(c9879387.operation)
	c:RegisterEffect(e11)
	
end
function c9879387.synfilter1(c)
	return c:IsCanHaveCounter(0x7e2)
end
function c9879387.atk(e,c)
	return e:GetHandler():GetCounter(0x7e2)*1000
end


function c9879387.acfil(c)
	return c:IsFaceup()
end  
function c9879387.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c9879387.acfil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,c9879387.acfil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9879387.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
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
end