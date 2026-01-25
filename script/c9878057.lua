--鹤乃·菲莉希亚
function c9878057.initial_effect(c)
	aux.AddCodeList(c,9877951,9877877)

	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_POSITION)
	e13:SetType(EFFECT_TYPE_QUICK_O) 
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetHintTiming(0,TIMING_END_PHASE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetOperation(c9878057.desop)
	c:RegisterEffect(e13)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9878057,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,9878057)
	e1:SetCondition(c9878057.thcon)
	e1:SetTarget(c9878057.thtg)
	e1:SetOperation(c9878057.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c9878057.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local op=0
	 op=Duel.SelectOption(tp,aux.Stringid(9878057,0),aux.Stringid(9878057,1))+1
			if op==1 then
				local e11=Effect.CreateEffect(e:GetHandler())
				e11:SetDescription(aux.Stringid(9878057,2))
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_ADD_CODE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e11:SetValue(9877877)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e11)
			else
				local e11=Effect.CreateEffect(e:GetHandler())
				e11:SetDescription(aux.Stringid(9878057,3))
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_ADD_CODE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e11:SetValue(9877951)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e11)
			end 
end



function c9878057.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_REDIRECT)
end
function c9878057.thfilter(c)
	return aux.IsCodeListed(c,9877877) and c:IsAbleToHand()
end
function c9878057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878057.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9878057.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878057.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end