--黑之拷问官 加姆
local s, id, o = GetID()
function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH + CATEGORY_DESTROY + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end

function s.efilter(e, te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttackBelow(e:GetHandler():GetAttack())
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	return ep == 1 - tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.filter(c)
    return c:IsSetCard(0x5fe0) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local rc = re:GetHandler()
	local c = e:GetHandler()
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil) and c:IsDestructable(e) --原数：破坏的卡从发动效果的卡变为自己
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SEARCH + CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
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
    local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.Destroy(c, REASON_EFFECT) > 0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
            local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
            Duel.SendtoHand(g, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, g)
        end
	end
    s.cannotsp(e:GetHandler(), tp)
end