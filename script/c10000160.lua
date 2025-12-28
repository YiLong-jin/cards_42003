--呼啸山庄
local s, id, o = GetID()

function s.initial_effect(c)
    aux.AddCodeList(c, 10000157, 10000158)
    local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON + CATEGORY_SEARCH + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1, id)
    e3:SetCondition(s.spcond)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

function s.filter(c)
    return c:IsSetCard(0xafe4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    local tc = g:GetFirst()
    if tc then
        Duel.SendtoHand(tc, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, tc)
        if tc:IsSummonable(true, nil) and Duel.GetMZoneCount(tp) > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
            Duel.BreakEffect()
            Duel.ShuffleHand(tp)
            Duel.Summon(tp, tc, true, nil)
        end
    end
end

function s.damcon(e, tp, eg, ep, ev, re, r, rp)
    return rp == tp and re:GetHandler():IsSetCard(0xafe4) and not re:GetHandler():IsCode(id)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
    Duel.SetLP(tp, Duel.GetLP(tp) - 200)
end

function s.spcond(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0 and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_GRAVE, 0, 1, nil, 10000157)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetMZoneCount(tp) > 0 and Duel.IsPlayerCanSpecialSummonMonster(tp, 10000158, nil, TYPES_TOKEN_MONSTER, 3000, 3000, 7, RACE_FAIRY, ATTRIBUTE_LIGHT)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetMZoneCount(tp) <= 0 or not Duel.IsPlayerCanSpecialSummonMonster(tp, 10000158, nil, TYPES_TOKEN_MONSTER, 3000, 3000, 7, RACE_FAIRY, ATTRIBUTE_LIGHT) then return end
    local token = Duel.CreateToken(tp, 10000158)
    Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP)
end