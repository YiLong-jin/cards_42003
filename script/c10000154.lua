--埃德加·林顿
local s, id, o = GetID()

function s.initial_effect(c)
    aux.AddCodeList(c, 10000157)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCountLimit(1)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_MAIN_END)
    e1:SetCost(s.generalcost)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOHAND + CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
    e2:SetCost(s.generalcost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_NORMALSUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
end

function s.counterfilter(c)
    return ((c:GetSummonLocation() & (LOCATION_HAND | LOCATION_DECK)) == 0) or c:IsAttribute(ATTRIBUTE_DARK)
end

function s.generalcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetCustomActivityCount(id, tp, ACTIVITY_SUMMON) == 0 and Duel.GetCustomActivityCount(id, tp, ACTIVITY_NORMALSUMMON) == 0 and Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) == 0
    end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE + PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1, tp)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2, tp)
end

function s.sumlimit(e, c, sump, sumtype, sumpos, targetp, se)
    return c:IsLocation(LOCATION_HAND | LOCATION_DECK) and (not c:IsAttribute(ATTRIBUTE_DARK))
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1) or (Duel.GetCurrentPhase() == PHASE_MAIN2)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local flag = 0
    if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 10000157) then
        flag = LOCATION_ONFIELD
    end
    local dg = Duel.GetMatchingGroup(Card.IsDestructable, tp, LOCATION_ONFIELD, flag, nil, e)
    if chk == 0 then
        return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and Duel.GetMZoneCount(tp) > 0 and #dg > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, dg, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        local flag = 0
        if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_ONFIELD, 0, 1, nil, 10000157) then
            flag = LOCATION_ONFIELD
        end
        local dg = Duel.GetMatchingGroup(Card.IsDestructable, tp, LOCATION_ONFIELD, flag, nil, e)
        if dg:GetCount() > 0 then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
            local sg = dg:Select(tp, 1, 1, nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg, REASON_EFFECT)
		end
    end
end

function s.s2filter(c, e, tp, ft)
	return c:IsSetCard(0xafe4) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() 
        or (ft > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false))) and
        not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local ft = Duel.GetMZoneCount(tp)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.s2filter, tp, LOCATION_REMOVED, 0, 1, nil, e, tp, ft)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_REMOVED)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local ft = Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local g = Duel.SelectMatchingCard(tp, s.s2filter, tp, LOCATION_REMOVED, 0, 1, 1, nil, e, tp, ft)
    local tc=g:GetFirst()
	if tc then
        local opnum;
        if ft > 0 and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false)
            and (not tc:IsAbleToHand() or Duel.SelectOption(tp, 1190, 1152) == 1) then
            opnum = Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
            if opnum then
                local e1 = Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CHANGE_LEVEL)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(7)
                tc:RegisterEffect(e1)
                Duel.SpecialSummonComplete()
            end
        else
            opnum = (Duel.SendtoHand(tc, nil, REASON_EFFECT) > 0)
			Duel.ConfirmCards(1 - tp, tc)
        end
        if opnum then
            local rg = Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove), tp, 0, LOCATION_GRAVE, nil)
            if #rg > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
                local mg = rg:Select(tp, 1, 1, nil)
                Duel.Remove(mg, POS_FACEUP, REASON_EFFECT)
            end
        end
    end
end