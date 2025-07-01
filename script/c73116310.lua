function c73116310.initial_effect(c)	
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN+EVENT_CHAINING)
	e1:SetCountLimit(1,73116310)
	e1:SetCondition(c73116310.condition)
	e1:SetTarget(c73116310.target)
	e1:SetOperation(c73116310.operation)
	c:RegisterEffect(e1)
end
function c73116310.condition(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c73116310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and re and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		return b1 or b2
	end
	local op=Duel.SelectEffect(tp,
		{true,aux.Stringid(73116310,0)},
		{true,aux.Stringid(73116310,1)}  
	)
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	else
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c73116310.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)<=0 then return end
	if op==1 then
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.NegateActivation(ev)
			Duel.Destroy(eg,REASON_EFFECT)
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end