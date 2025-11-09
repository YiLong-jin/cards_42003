--黑之骑士 琳达梅尔
local s, id, o = GetID()

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

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    -- 经原数，此效果已删除
    -- local e3 = Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_SINGLE)
	-- e3:SetCode(EFFECT_IMMUNE_EFFECT)
	-- e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e3:SetRange(LOCATION_MZONE)
	-- e3:SetValue(s.efilter)
	-- c:RegisterEffect(e3)
end

function s.filter(c)
    return c:IsSetCard(0x5fe0) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_SEARCH + CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if g then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
    s.cannotsp(e:GetHandler(), tp) --特殊召唤限制
end

-- function s.efilter(e, te)
--     return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttack(0)
-- end