\--未能倾听的话语
local s, id, o = GetID()

function s.initial_effect(c)
    aux.AddCodeList(c, 10000152)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(1165)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, TIMING_END_PHASE)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	-- c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(1192)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0, TIMING_END_PHASE)
	e2:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
    c:RegisterEffect(e2)
end

function s.spfilter(c, e, tp, overlay)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0xafe4) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, tp, false, false) and Duel.GetLocationCountFromEx(tp, tp, overlay, c)
end

function s.heathclifffilter(c, e, tp)
    return c:IsFaceup() and c:IsCode(10000152) and aux.MustMaterialCheck(c, tp, EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, c)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return s.heathclifffilter(chkc, e, tp) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.heathclifffilter, tp, LOCATION_MZONE, 0, 1, nil, e, tp)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    Duel.SelectTarget(tp, s.heathclifffilter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local heath = Duel.GetFirstTarget()
    if not heath:IsRelateToEffect(e) then return end
    if not aux.MustMaterialCheck(heath, tp, EFFECT_MUST_BE_XMATERIAL) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, heath)
    local tc = g:GetFirst()
    if tc then
        local mg = heath:GetOverlayGroup()
		if mg:GetCount() ~= 0 then
			Duel.Overlay(sc, mg)
		end
		tc:SetMaterial(Group.FromCards(heath))
		Duel.Overlay(tc, Group.FromCards(heath))
		Duel.SpecialSummon(tc, SUMMON_TYPE_XYZ, tp, tp, false, false, POS_FACEUP)
		tc:CompleteProcedure()
    end
end

function s.remfilter(c, tp)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xafe4) and c:IsAbleToRemove(tp, POS_FACEUP, REASON_EFFECT+REASON_TEMPORARY)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return s.remfilter(chkc, tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.remfilter, tp, LOCATION_MZONE, 0, 1, nil, tp)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectTarget(tp, s.remfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, 0, 0)
end

function s.activate2(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    if Duel.Remove(tc, POS_FACEUP, REASON_EFFECT+REASON_TEMPORARY) > 0 then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1, 1)
        e1:SetValue(s.aclimit)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
        local e2 = Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE + PHASE_END)
        e2:SetReset(RESET_PHASE + PHASE_END)
        e2:SetLabelObject(tc)
        e2:SetCountLimit(1)
        e2:SetOperation(s.retop)
        Duel.RegisterEffect(e2, tp)
    end
end

function s.aclimit(e, re, tp)
    return re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.retop(e, tp, eg, ep, ev, re, r, rp)
    Duel.ReturnToField(e:GetLabelObject())
end