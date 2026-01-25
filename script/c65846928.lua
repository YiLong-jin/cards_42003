--破魔的妖梦
function c65846928.initial_effect(c)
	aux.AddCodeList(c,65846916)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846928+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65846928.target)
	e1:SetOperation(c65846928.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65846928.tntg)
	e2:SetOperation(c65846928.tnop)
	c:RegisterEffect(e2)
end
function c65846928.filter(c)
	return aux.IsCodeListed(c,65846916) and c:IsAbleToGrave()
end
function c65846928.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846928.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65846928.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846928.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c65846928.tfilter(c)
	return c:IsFaceup() and c:IsRace(0x10) and not c:IsType(TYPE_TUNER)
		and c:IsLevelAbove(1)
end
function c65846928.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65846928.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846928.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65846928.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65846928.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TUNER)
		e1:SetValue(c65846928.tunerval)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c65846928.tunerval(e,sc)
	return sc:IsControler(e:GetHandlerPlayer())
end