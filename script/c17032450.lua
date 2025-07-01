--新序系6 以太阿波菲斯
function c17032450.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c17032450.ovfilter,aux.Stringid(17032450,1),2,c17032450.xyzop)
	c:EnableReviveLimit()
	--addown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17032450,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c17032450.cost)
	e1:SetTarget(c17032450.target)
	e1:SetOperation(c17032450.operation)
	c:RegisterEffect(e1)
end
c17032450.New_Order=6
function c17032450.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and (c:IsDiscardable() or c:IsAbleToHand())
end
function c17032450.ovfilter(c)
	return c:IsFaceup() and c.New_Order and c:IsRank(4)
end
function c17032450.xyzop(e,tp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,17032500)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c17032450.cfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c17032450.cfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,17032500)
		fe:UseCountLimit(tp)
		Duel.SendtoHand(tc,nil,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
	end
end
function c17032450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17032450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17032450.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c17032450.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end