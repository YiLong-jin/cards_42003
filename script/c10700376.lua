--梅莉小姐
function c10700376.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10700376)
	e1:SetCondition(c10700376.negcon)
	e1:SetCost(c10700376.negcost)
	e1:SetTarget(c10700376.negtg)
	e1:SetOperation(c10700376.negop)
	c:RegisterEffect(e1) 
	c10700376.discard_effect=e1   
end
function c10700376.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc
end
function c10700376.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c10700376.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local tc=g:GetFirst()
	if re:GetHandler():IsAbleToRemove() and tc:IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c10700376.negop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local reg=Group.CreateGroup()
	reg:AddCard(tc)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and tc:IsRelateToEffect(re) then
		reg:AddCard(re:GetHandler())
		Duel.Remove(reg,POS_FACEUP,REASON_EFFECT)
	end
end