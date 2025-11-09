--黑之裁判长 巴风特
local s, id, o = GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
    aux.AddFusionProcFunRep2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0x5fe0), 2, 127, false)

    local e1 = Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	-- e1:SetTargetRange(LOCATION_MZONE, 0)
	-- e1:SetTarget(s.etarget)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)

	-- local e2 = Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetCode(EFFECT_UPDATE_ATTACK)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetValue(s.val)
	-- c:RegisterEffect(e2)
	-- local e3 = e2:Clone()
	-- e3:SetCode(EFFECT_UPDATE_DEFENSE)
	-- c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.condition)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	e4:SetCountLimit(1, id)
	c:RegisterEffect(e4)
end

-- function s.etarget(e, c)
-- 	return c:IsSetCard(0x5fe0)
-- end

function s.efilter(e, re)
	return re:GetOwnerPlayer() ~= e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL + TYPE_TRAP)
end

function s.val(e, c)
	return Duel.GetFieldGroupCount(c:GetControler(), 0, LOCATION_MZONE) * 200
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	for i = 1, ev do
		local te, tgp = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER)
		if tgp ~= tp and te:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	local ng = Group.CreateGroup()
	for i = 1, ev do
		local te, tgp = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER)
		if tgp ~= tp and te:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(i) then
			local tc = te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, ng, #ng, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	for i = 1, ev do
		local te, tgp = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER)
		if tgp ~= tp and te:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(i) then
			Duel.NegateActivation(i)
		end
	end
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.Hint(HINT_MESSAGE, tp, HINTMSG_DISCARD)
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD, nil)
end