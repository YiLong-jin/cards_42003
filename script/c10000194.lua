--地底都市 雅戈泰
local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard, 0x5fe0))
    e2:SetTargetRange(LOCATION_MZONE, 0)
    e2:SetValue(s.val)
    c:RegisterEffect(e2)
    local e3 = e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)

    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    -- e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetTarget(s.target)
    e4:SetOperation(s.operation)
    c:RegisterEffect(e4)
end

function s.val(e, c)
    return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, LOCATION_MZONE) * 100
end

function s.filter(c, e, tp)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5fe0) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk) --, chkc)
    --if chkc then
    --    return s.filter(chkc, e, tp) and chkc:IsLocation(LOCATION_HAND + LOCATION_GRAVE) and chkc:IsControler(tp)
    --end
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE + LOCATION_HAND, 0, 1, nil, e, tp) and Duel.GetMZoneCount(tp) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE + LOCATION_HAND)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetMZoneCount(tp) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.filter), tp, LOCATION_GRAVE + LOCATION_HAND, 0, 1, 1, nil, e, tp)
    if g then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end