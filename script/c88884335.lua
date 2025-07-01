--终焉之始端
function c88884335.initial_effect(c)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88884335)
	e1:SetCondition(c88884335.descon)
	e1:SetTarget(c88884335.destg)
	e1:SetOperation(c88884335.desop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,88884335)
	e2:SetCondition(c88884335.tocon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88884335.totg)
	e2:SetOperation(c88884335.toop)
	c:RegisterEffect(e2)
end
function c88884335.desfilter(c)
	return c:IsSetCard(0x8893)
end
function c88884335.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)~=0
end
function c88884335.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884335.desfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c88884335.desfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
end
function c88884335.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg1=Duel.SelectMatchingCard(tp,c88884335.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	local dg2=Duel.SelectMatchingCard(tp,c88884335.desfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Destroy(dg1+dg2,REASON_EFFECT)
end
function c88884335.tocon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_MZONE)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x8895) and re:GetHandler():IsType(TYPE_FUSION)
end
function c88884335.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c88884335.toop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end