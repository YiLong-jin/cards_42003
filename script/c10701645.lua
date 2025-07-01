--妖精吹息
function c10701645.initial_effect(c)
	aux.AddCodeList(c,25862681,4179255)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,10701645+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701645.rectg)
	e1:SetOperation(c10701645.recop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12541409,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c10701645.actcon)
	c:RegisterEffect(e2)	
end
function c10701645.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c10701645.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701645.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701645.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10701645.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c10701645.cfilter(c)
	return c:IsFaceup() and c:IsCode(25862681,4179255)
end
function c10701645.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c10701645.cfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsControler(1-tp) then
			if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			  local c=e:GetHandler()
			  local e1=Effect.CreateEffect(c)
			  e1:SetType(EFFECT_TYPE_FIELD)
			  e1:SetCode(EFFECT_DISABLE)
			  e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			  e1:SetTarget(c10701645.distg)
			  e1:SetLabelObject(tc)
			  e1:SetReset(RESET_PHASE+PHASE_END,2)
			  Duel.RegisterEffect(e1,tp)
			  local e2=Effect.CreateEffect(c)
			  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			  e2:SetCode(EVENT_CHAIN_SOLVING)
			  e2:SetCondition(c10701645.discon)
			  e2:SetOperation(c10701645.disop)
			  e2:SetLabelObject(tc)
			  e2:SetReset(RESET_PHASE+PHASE_END,2)
			  Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c10701645.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c10701645.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c10701645.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c10701645.actcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end