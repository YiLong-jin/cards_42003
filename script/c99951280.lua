--原始特拉大脑 西格玛
function c99951280.initial_effect(c)
    aux.AddSynchroMixProcedure(c, c99951280.matfilter1, nil, nil, aux.NonTuner(nil), 1, 99)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c)

    -- 灵摆效果①：P区空时，从额外表侧放置1张未来战灵摆怪兽
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, 99951280)
    e1:SetTarget(c99951280.pctg)
    e1:SetOperation(c99951280.pcop)
    c:RegisterEffect(e1)

    -- 灵摆效果②：P区有卡时，破坏那张卡，这张卡从P区特召
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1, 99951281)
    e2:SetCondition(c99951280.pencon)
    e2:SetTarget(c99951280.pentg)
    e2:SetOperation(c99951280.penop)
    c:RegisterEffect(e2)

    -- 怪兽效果①：炸卡 → 那之后放置灵摆
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(99951280, 0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1, 99951282)
    e3:SetTarget(c99951280.destg)
    e3:SetOperation(c99951280.desop)
    c:RegisterEffect(e3)

    -- 怪兽效果②：从场上离开时，放置到P区
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(99951280, 2))
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCountLimit(1, 99951283)
    e4:SetTarget(c99951280.sptg)
    e4:SetOperation(c99951280.spop)
    c:RegisterEffect(e4)
end

function c99951280.matfilter1(c)
    return c:IsSetCard(0x671) and c:IsSynchroType(TYPE_SYNCHRO)
end

-- ============================================================
-- 灵摆效果①：P区空时，从额外表侧放置
-- ============================================================
function c99951280.pcfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end

function c99951280.pctg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))
            and Duel.IsExistingMatchingCard(c99951280.pcfilter, tp, LOCATION_EXTRA, 0, 1, nil)
    end
end

function c99951280.pcop(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.CheckLocation(tp, LOCATION_PZONE, 0) and not Duel.CheckLocation(tp, LOCATION_PZONE, 1) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
    local g = Duel.SelectMatchingCard(tp, c99951280.pcfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
    end
end

-- ============================================================
-- 灵摆效果②：P区有卡时，破坏那张卡，这张卡特召
-- ============================================================
function c99951280.pencon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(nil, tp, LOCATION_PZONE, 0, 1, e:GetHandler())
end

function c99951280.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    local sc = Duel.GetFirstMatchingCard(nil, tp, LOCATION_PZONE, 0, e:GetHandler())
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sc, 1, 0, 0)
end

function c99951280.penop(e, tp, eg, ep, ev, re, r, rp)
    local sc = Duel.GetFirstMatchingCard(nil, tp, LOCATION_PZONE, 0, e:GetHandler())
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Destroy(sc, REASON_EFFECT) ~= 0 then
        local c = e:GetHandler()
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- 怪兽效果①：炸卡 → 那之后放置灵摆
-- ============================================================
function c99951280.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsOnField() end
    if chk == 0 then
        return Duel.IsExistingTarget(nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function c99951280.desop(e, tp, eg, ep, ev, re, r, rp)
    -- ★ 使用 GetFirstTarget() 获取目标卡
    local tc = Duel.GetFirstTarget()
    if not tc then return end

    if tc:IsRelateToEffect(e) then
        local destroyed = Duel.Destroy(tc, REASON_EFFECT)

        if destroyed > 0 then
            if Duel.GetMatchingGroupCount(c99951280.penfilter, tp, LOCATION_EXTRA, 0, nil) > 0
                and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))
                and Duel.SelectYesNo(tp, aux.Stringid(99951280, 3)) then

                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
                local g = Duel.SelectMatchingCard(tp, c99951280.penfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
                local placed = g:GetFirst()
                if placed then
                    Duel.MoveToField(placed, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
                end
            end
        end
    end
end

function c99951280.penfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end

-- ============================================================
-- 怪兽效果②：从场上离开时，放置到P区
-- ============================================================
function c99951280.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
    end
end

function c99951280.spop(e, tp, eg, ep, ev, re, r, rp)
    if not Duel.CheckLocation(tp, LOCATION_PZONE, 0) and not Duel.CheckLocation(tp, LOCATION_PZONE, 1) then return end
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
    end
end