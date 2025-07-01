--跨维度战舰 科芬6
function c9990450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990450+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9990450.activate)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9990450,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9990451)
	e3:SetCondition(c9990450.atkcon)
	e3:SetOperation(c9990450.atkop)
	c:RegisterEffect(e3)
end
function c9990450.thfilter1(c)
	return c:IsSetCard(0x672) and c:IsAbleToHand()
end
function c9990450.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9990450.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9990450,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9990450.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x671) and c:IsLocation(LOCATION_EXTRA)
end
function c9990450.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x673) and c:IsControler(tp)
end
function c9990450.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9990450.cfilter,1,nil,tp)
end
function c9990450.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(500)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
