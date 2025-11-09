--黑之裁决者 七海莉雅
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
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SEARCH + CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE + LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.con)
    e1:SetTarget(s.tg)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

function s.con(e, tp, eg, ep, ev, re, r, rp)
	return not (ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED))
end

function s.filter(c)
    return (c:IsSetCard(0x5fe0) or c:IsType(TYPE_FIELD)) and c:IsAbleToHand()
end

-- function s.filter2(c)
--     return (c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL + TYPE_TRAP)) and c:IsAbleToHand()
-- end

-- function s.filterenable(c)
--     return c:IsSetCard(0x5fe0) and c:IsLevelAbove(8) and c:IsFaceup()
-- end

function s.tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        if not e:GetHandler():IsDestructable(e) then return false end
        if Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil) then return true end
        -- return Duel.IsExistingMatchingCard(s.filterenable, tp, LOCATION_MZONE, 0, 1, nil) and Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_DECK, 0, 1, nil)
        return false
    end
    Duel.SetOperationInfo(0, CATEGORY_SEARCH + CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.op(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then
        s.cannotsp(e:GetHandler(), tp)
        return
    end
    if Duel.Destroy(e:GetHandler(), REASON_EFFECT) > 0 then
        local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_DECK, 0, nil)
        -- if Duel.IsExistingMatchingCard(s.filterenable, tp, LOCATION_MZONE, 0, 1, nil) then
        --     local g2 = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_DECK, 0, nil)
        --     if g then
        --         g:Merge(g2)
        --     else
        --         g = g2
        --     end
        -- end
        if g then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
            local sg = g:Select(tp, 1, 1, nil)
            Duel.SendtoHand(sg, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, sg)
        end
    end
    s.cannotsp(e:GetHandler(), tp)
end

function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT + REASON_BATTLE)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter, 1, nil)
end

function s.setfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetMZoneCount(tp) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) 
        and Duel.IsExistingMatchingCard(s.setfilter, tp, 0, LOCATION_MZONE, 1)
    end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_POSITION, nil, 1, 1 - tp, LOCATION_MZONE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
            local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, 0, LOCATION_MZONE, 1, 1, nil)
            Duel.ChangePosition(g, POS_FACEDOWN_DEFENSE)
        end
	end
    s.cannotsp(c, tp)
end