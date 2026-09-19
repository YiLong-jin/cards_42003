--星之交替龙
function c65848063.initial_effect(c)
	aux.AddCodeList(c,65848059)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,65848063)
	e1:SetCondition(c65848063.thcon)
	e1:SetTarget(c65848063.thtg)
	e1:SetOperation(c65848063.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65848063,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65848063.thcon2)
	e2:SetTarget(c65848063.thtg2)
	e2:SetOperation(c65848063.thop2)
	c:RegisterEffect(e2)
	if not c65848063.global_check then
		c65848063.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c65848063.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65848063.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c65848063.tfilter(c)
	return (c:IsCode(65848059) or aux.IsCodeListed(c,65848059) and c:IsType(0x6)) and c:IsAbleToHand()
end
function c65848063.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and c65848063.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65848063.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and c:IsAbleToGrave() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c65848063.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function c65848063.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end
end
function c65848063.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c65848063.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c65848063.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,65848063,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c65848063.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,65848063,RESET_PHASE+PHASE_END,0,1) end
end
function c65848063.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65848059)~=0
end
function c65848063.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,65848072)==0 end
	Duel.RegisterFlagEffect(tp,65848072,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c65848063.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end