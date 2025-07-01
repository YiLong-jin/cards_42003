--アマルガムの蛇　デーモ・ ドラゴ
function c88884328.initial_effect(c)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,88884328)
	e1:SetTarget(c88884328.destg)
	e1:SetOperation(c88884328.desop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,18884328)
	e2:SetTarget(c88884328.totg)
	e2:SetOperation(c88884328.toop)
	c:RegisterEffect(e2)
end
function c88884328.desfilter(c)
	return (c:IsSetCard(0x8893) or c:IsSetCard(0x8895))
end
function c88884328.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884328.desfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c88884328.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c88884328.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c88884328.tofilter(c,e,tp)
	return c:IsSetCard(0x8893) and not c:IsCode(88884328) and c:IsAbleToHand()
end
function c88884328.totg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88884328.tofilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c88884328.tofilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c88884328.tofilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c88884328.toop(e,tp,eg,ep,ev,r,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc) end
end