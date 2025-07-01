--終末の到来
function c88884333.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88884333)
	e1:SetTarget(c88884333.target)
	e1:SetOperation(c88884333.activate)
	c:RegisterEffect(e1)
	--recycle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,88884333)
	e2:SetCondition(c88884333.recon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88884333.retg)
	e2:SetOperation(c88884333.reop)
	c:RegisterEffect(e2)
end
function c88884333.filter(c)
	return (c:IsSetCard(0x8893) or c:IsSetCard(0x8895)) and c:IsAbleToHand()
end
function c88884333.filter0(c)
	return c:IsType(TYPE_MONSTER)
end
function c88884333.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884333.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
end
function c88884333.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88884333.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return false end
	local tc=g:GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c88884333.filter0,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c88884333.tdfilter(c)
	return c:IsSetCard(0x8893) and c:IsAbleToDeck()
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c88884333.recon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_MZONE)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x8895) and re:GetHandler():IsType(TYPE_FUSION)
end
function c88884333.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingTarget(c88884333.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c88884333.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c88884333.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	if #g==0 then return false end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end