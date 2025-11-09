--黑之异端审问官 佩德
local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop) --原数：添加特殊召唤限制
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetTarget(s.target)
    e2:SetCountLimit(1, id + 1)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
end

function s.spcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	return Duel.GetMZoneCount(tp) > 0
end

function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    s.cannotsp(c, tp)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- return true
        return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
    end
    -- Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 300)
    Duel.SetOperationInfo(0, CATEGORY_SEARCH + CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.filter(c)
    return c:IsSetCard(0x5fe0) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
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


function s.operation(e, tp, eg, ep, ev, re, r, rp)
    -- local alp = Duel.GetLP(1 - tp)
    -- Duel.SetLP(1 - tp, alp - 300)
    -- Duel.Recover(tp, 300, REASON_EFFECT)
    -- if Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
    --     Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local sg = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if sg then
        Duel.SendtoHand(sg, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, sg)
    end
    -- end
    -- s.cannotsp(e:GetHandler(), tp) --原数：移除特殊召唤限制
end
