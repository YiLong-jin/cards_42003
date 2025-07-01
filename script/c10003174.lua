--赛马娘 优秀素质
function c10003174.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10003174)
	e1:SetCondition(c10003174.condition)
	e1:SetCost(c10003174.cost)
	e1:SetTarget(c10003174.target)
	e1:SetOperation(c10003174.operation)
	c:RegisterEffect(e1)
end

function c10003174.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x417) and (c:IsType(TYPE_LINK) or c:IsType(TYPE_SYNCHRO))
end

function c10003174.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10003174.cfilter,tp,LOCATION_MZONE,0,1,nil)and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c10003174.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c10003174.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
end
function c10003174.operation(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end
end

