--启程的交融公主
function c65848064.initial_effect(c)
	aux.AddCodeList(c,65848059)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65848064,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,65848064)
	e1:SetCondition(c65848064.thcon)
	e1:SetTarget(c65848064.thtg)
	e1:SetOperation(c65848064.thop)
	c:RegisterEffect(e1)	
	aux.EnableChangeCode(c,65848059,LOCATION_MZONE+LOCATION_GRAVE)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65848064,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65848064.thcon2)
	e2:SetTarget(c65848064.thtg2)
	e2:SetOperation(c65848064.thop2)
	c:RegisterEffect(e2)
	if not c65848064.global_check then
		c65848064.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c65848064.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65848064.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c65848064.filter(c)
	return aux.IsCodeListed(c,65848059) and c:IsType(0x6) and c:IsAbleToHand()
end
function c65848064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65848064.filter,tp,LOCATION_DECK,0,1,nil) and c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65848064.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if c:IsRelateToChain() and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		if c:GetOriginalCode()==65848064 then
			c:RegisterFlagEffect(65848064,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(65848064,1))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(fid)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetCondition(c65848064.retcon)
			e1:SetOperation(c65848064.retop)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65848064.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c65848064.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(65848064)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c65848064.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c65848064.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c65848064.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c65848064.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,65848049,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c65848064.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,65848049,RESET_PHASE+PHASE_END,0,1) end
end
function c65848064.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65848049)~=0
end
function c65848064.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,65848064)==0 end
	Duel.RegisterFlagEffect(tp,65848064,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c65848064.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end