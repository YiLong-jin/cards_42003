-- 诡异神器 地平线·冷匣
-- 地属性 机械族 超量/灵摆/效果
-- ATK 2550 DEF 2000
-- 灵摆刻度：←7 【灵摆】 7→
-- 这个卡名规则上也当作「未来战」卡来使用。

local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c, false)

    aux.AddXyzProcedureLevelFree(c, s.mfilter, nil, 2, 2)
    c:EnableReviveLimit()

    -- 灵摆效果：连锁2以上保护本家
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1, id)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetOperation(s.pen_op)
    c:RegisterEffect(e1)

    -- ★ 怪兽①：二速炸卡（自己1张 + 对方最多2张）+ 补素材
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
    e2:SetCountLimit(1, id + 1)
    e2:SetCost(s.cost1)
    e2:SetTarget(s.tg1)
    e2:SetOperation(s.op1)
    c:RegisterEffect(e2)

    -- 怪兽②攻击表示：取除素材 → 墓地特召本家 → 贴P区
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1, id + 2)
    e3:SetCondition(function(e) return e:GetHandler():IsAttackPos() end)
    e3:SetCost(s.cost2)
    e3:SetTarget(s.tg2)
    e3:SetOperation(s.op2)
    c:RegisterEffect(e3)

    -- 怪兽②守备表示：本家取对象抗性（不包括自身）
    local e4 = Effect.CreateEffect(c)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(LOCATION_MZONE, 0)
    e4:SetCondition(function(e) return e:GetHandler():IsDefensePos() end)
    e4:SetTarget(s.def_tg)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
end

function s.mfilter(c, xyzc)
    return c:IsSetCard(0x671) and c:IsSynchroType(TYPE_SYNCHRO)
end

-- ============================================================
-- 灵摆效果
-- ============================================================
function s.pen_op(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetCurrentChain() <= 1 then return end
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end

    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD, 0)
    e1:SetValue(function(e, te) return te:GetOwnerPlayer() ~= tp end)
    e1:SetTarget(function(e, c) return c:IsSetCard(0x671) end)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1, tp)
end

-- ============================================================
-- 怪兽①：二速炸卡 + 补素材
-- ============================================================
function s.cost1(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return c:GetOverlayCount() > 0 end
    c:RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.tg1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return false end
    if chk == 0 then
        return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_ONFIELD, 0, 1, nil)
            and Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g1 = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g2 = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, 2, nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g1, g1:GetCount(), 0, 0)
end

function s.op1(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    local sg = g:Filter(Card.IsRelateToEffect, nil, e)
    if Duel.Destroy(sg, REASON_EFFECT) == 0 then return end

    -- 补素材
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local extra = Duel.GetMatchingGroup(function(card)
        return card:IsFaceup() and card:IsSetCard(0x671) and card:IsType(TYPE_MONSTER)
    end, tp, LOCATION_EXTRA, 0, nil)
    if #extra > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
        local sg = extra:Select(tp, 1, 1, nil)
        if #sg > 0 then
            Duel.Overlay(c, sg)
        end
    end
end

-- ============================================================
-- 怪兽②守备
-- ============================================================
function s.def_tg(e, c)
    return c:IsSetCard(0x671)
end

-- ============================================================
-- 怪兽②攻击
-- ============================================================
function s.cost2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return c:GetOverlayCount() > 0 end
    c:RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(function(c)
            return c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        end, tp, LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end

function s.op2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, function(card)
        return card:IsSetCard(0x671) and card:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    if #g == 0 then return end
    local tc = g:GetFirst()
    if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) == 0 then return end

    if not (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
        return
    end
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then return end
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
    end
end