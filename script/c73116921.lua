--方解式·「白垩」
function c73116921.initial_effect(c)
----------------------------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,73116921)
	e1:SetTarget(c73116921.target)
	e1:SetOperation(c73116921.activate)
	c:RegisterEffect(e1)
----------------------------------------------------------------------------------------------------------------------------------------
	--广告位招租--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73116921,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,73116921+10086)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c73116921.thcon)
	e2:SetTarget(c73116921.thtg)
	e2:SetOperation(c73116921.thop)
	c:RegisterEffect(e2)
end
function c73116921.tgfilter(c)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c73116921.cfilter,c:GetControler(),LOCATION_DECK,0,1,nil,c)
end
function c73116921.cfilter(c,tc)
	return c:IsSetCard(0x7ac) and not c:IsCode(tc:GetCode()) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c73116921.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c73116921.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73116921.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c73116921.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c73116921.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c73116921.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		local gc=g:GetFirst()
		if Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(gc:GetCode())
			tc:RegisterEffect(e1)
		end
	end
end
function c73116921.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ac)
end
function c73116921.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c73116921.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c73116921.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c73116921.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end