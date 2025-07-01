--命运石之门的选择
function c99900530.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99900530,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99900530)
	e1:SetCondition(c99900530.con1)
	e1:SetCost(c99900530.discost)
	e1:SetTarget(c99900530.tg1)
	e1:SetOperation(c99900530.op1)
	c:RegisterEffect(e1)
--
end
--
function c99900530.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_DISABLE) or re:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
--
function c99900530.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c99900530.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
--
function c99900530.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--

