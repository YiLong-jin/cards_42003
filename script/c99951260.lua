-- 格伦德尔204
local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- ============================================================
    -- 灵摆效果：从额外表侧回收灵摆怪兽
    -- ============================================================
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pencon)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- ============================================================
    -- 怪兽效果①：召唤·特殊召唤成功时，从额外表侧·卡组特召并破坏
    -- ============================================================
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.smtg)
    e2:SetOperation(s.smop)
    c:RegisterEffect(e2)

    local e3 = e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)

    -- ============================================================
    -- 怪兽效果②：额外表侧时，放置到P区
    -- ============================================================
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 2))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1, id + 2)
    e4:SetCondition(s.excon)
    e4:SetTarget(s.extg)
    e4:SetOperation(s.exop)
    c:RegisterEffect(e4)
end

-- ============================================================
-- 灵摆效果
-- ============================================================
function s.pencon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local pzone = Duel.GetFieldGroup(tp, LOCATION_PZONE, 0)
    if pzone:GetCount() < 2 then return false end
    local other = pzone:GetFirst()
    if other == c then other = pzone:GetNext() end
    return other and other:IsSetCard(0x671)
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_EXTRA, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_EXTRA)
end

function s.penfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

-- ============================================================
-- 怪兽效果①
-- ============================================================
function s.spfilter(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
        and (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() or c:IsLocation(LOCATION_DECK))
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.smtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA + LOCATION_DECK, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA + LOCATION_DECK)
end

function s.smop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA + LOCATION_DECK, 0, 1, 1, nil, e, tp)
    if #g == 0 then return end
    local tc = g:GetFirst()

    -- 1. 特殊召唤
    if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) == 0 then return end

    -- 2. ★ 那之后，那只怪兽破坏
    if  tc:IsLocation(LOCATION_MZONE)  then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end

-- ============================================================
-- 怪兽效果②
-- ============================================================
function s.excon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsFaceup()
end

function s.extg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
    end
end

function s.exop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
        Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
    end
end