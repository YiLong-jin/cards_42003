--芝士 魔法
function c40800014.initial_effect(c)
	aux.AddCodeList(c,40800000)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40801014)
	e1:SetTarget(c40800014.target)
	e1:SetOperation(c40800014.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,40800014)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c40800014.thtg)
	e3:SetOperation(c40800014.thop)
	c:RegisterEffect(e3)
end
c40800014.SetCard_RR_ZS=true 
function c40800014.filter(c)
	return c.SetCard_RR_ZS and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40800014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40800014.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40800014.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40800014.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40800014.thfilter(c,tp)
	return c.SetCard_RR_ZS and c:IsFaceup() and (c:IsAbleToHand() and not c:IsAbleToExtra() or c:IsAbleToExtra() and not c:IsType(TYPE_PENDULUM) or c:IsCode(40800000) and Duel.IsPlayerCanDraw(tp,1) and (c:IsAbleToExtra() or c:IsAbleToHand())) and not c:IsCode(40800014)
end
function c40800014.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40800014.thfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c40800014.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40800014.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	if g:GetFirst():IsCode(40800000) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40800014.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if not tc:IsAbleToExtra() then
		if aux.NecroValleyFilter()(tc) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	else
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
	if tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) and tc:IsCode(40800000) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end