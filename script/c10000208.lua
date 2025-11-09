--黑之执行官 夏洛特
local s, id, o = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    e1:SetCountLimit(1, id)
	c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(s.cost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetCountLimit(1, id + 1)
    c:RegisterEffect(e2)
end

function s.cannotsp(c, tp)
    local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function s.splimit(e, c)
	return not c:IsSetCard(0x5fe0)
end

function s.spcon(e, c)
    if c == nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(), LOCATION_MZONE, 0) < Duel.GetFieldGroupCount(c:GetControler(), 0, LOCATION_MZONE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    s.cannotsp(c, tp)
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(), REASON_COST)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_MZONE, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, 1 - tp, LOCATION_MZONE)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, 0, LOCATION_MZONE, 1, 1, nil)
    if g then
        Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
    end
end