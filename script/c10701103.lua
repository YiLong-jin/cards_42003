--高速魔法－增压
function c10701103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10701103.cttg)
	e1:SetOperation(c10701103.ctop)
	c:RegisterEffect(e1)	
end
function c10701103.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x104d,4)
end
function c10701103.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and c10701103.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701103.ctfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectTarget(tp,c10701103.ctfilter,tp,LOCATION_FZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c10701103.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x104d,4)
		tc:RegisterFlagEffect(10701103,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c10701103.rmcon)
		e1:SetOperation(c10701103.rmop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10701103.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(10701103)==e:GetLabel()
end
function c10701103.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local n=tc:GetCounter(0x104d)
	if n>=2 then tc:RemoveCounter(tp,0x104d,n-1,REASON_EFFECT) end
end