local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- ========== 灵摆效果 ==========
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pencon)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- ========== 怪兽效果①：抽卡以外加入手卡时特召 ==========
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetCountLimit(1, id + 1)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)

    -- ========== 怪兽效果②：作为同调/超量素材时赋予效果 ==========
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(s.matcon)
    e3:SetOperation(s.matop)
    c:RegisterEffect(e3)
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
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 0, tp, LOCATION_PZONE)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_DECK)
end

function s.penfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    -- 1. 破坏自己P区全部
    local pzone_group = Duel.GetFieldGroup(tp, LOCATION_PZONE, 0)
    if #pzone_group > 0 then
        Duel.Destroy(pzone_group, REASON_EFFECT)
    end

    -- 2. 从手卡·卡组选1只未来战机械族怪兽
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
    local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil)
    if #g == 0 then return end
    local tc = g:GetFirst()

    -- 3. 选择放置还是特召
    local opt = Duel.SelectOption(tp, aux.Stringid(id, 2), aux.Stringid(id, 3))
    if opt == 0 then
        -- 放置到P区
        if Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1) then
            Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
        end
    else
        -- 特殊召唤
        if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
            Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
        end
    end
end

-- ============================================================
-- 怪兽效果①：抽卡以外加入手卡时特召
-- ============================================================
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return not e:GetHandler():IsReason(REASON_DRAW)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- 怪兽效果②：作为同调/超量素材时赋予效果
-- ============================================================
function s.matcon(e, tp, eg, ep, ev, re, r, rp)
    return (r == REASON_SYNCHRO or r == REASON_XYZ)
        and e:GetHandler():GetReasonCard():IsSetCard(0x671)
end

function s.matop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local rc = c:GetReasonCard()
    if not rc then return end

    local e1 = Effect.CreateEffect(rc)
    e1:SetDescription(aux.Stringid(id, 4))
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_TOGRAVE + CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1, id + 2)
    e1:SetTarget(s.give_tg)
    e1:SetOperation(s.give_op)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD)
    rc:RegisterEffect(e1, true)

    if not rc:IsType(TYPE_EFFECT) then
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_ADD_TYPE)
        e2:SetValue(TYPE_EFFECT)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD)
        rc:RegisterEffect(e2, true)
    end

    rc:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 5))
end

-- ============================================================
-- 赋予效果的 target（三者都必须有1）
-- ============================================================
function s.destroy_filter(c)
    return c:IsFaceup() and c:IsDestructable()
end

function s.destroy_check(tp)
    local g = Duel.GetMatchingGroup(s.destroy_filter, 1 - tp, LOCATION_ONFIELD, 0, nil)
    return #g > 0
end

function s.give_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    local exg = Duel.GetFieldGroup(tp, LOCATION_EXTRA, 0):Filter(Card.IsFaceup, nil)
    local ct = math.floor(#exg / 3)

    if chk == 0 then
        local has_destroy = s.destroy_check(tp)
        local has_extra = exg:IsExists(Card.IsFaceup, 1, nil)
        local has_grave = Duel.IsExistingMatchingCard(Card.IsAbleToDeck, tp, LOCATION_GRAVE, 1, 1, nil)
        return ct > 0 and has_destroy and has_extra and has_grave
    end

    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 1 - tp, LOCATION_ONFIELD)
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_EXTRA)
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 0, tp, LOCATION_GRAVE)
end

-- ============================================================
-- 赋予效果的 operation
-- ============================================================
function s.give_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local exg = Duel.GetFieldGroup(tp, LOCATION_EXTRA, 0):Filter(Card.IsFaceup, nil)
    local ct = math.floor(#exg / 3)
    if ct == 0 then return end

    local success_destroy = 0
    local success_send = 0

    -- 1. ★ 选对方场上最多 ct 张卡破坏（下限1）
    local dg = Duel.GetMatchingGroup(s.destroy_filter, 1 - tp, LOCATION_ONFIELD, 0, nil)
    if #dg > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
        local sg1 = dg:Select(tp, 1, ct, nil)
        if sg1 and #sg1 > 0 then
            success_destroy = Duel.Destroy(sg1, REASON_EFFECT)
        end
    end

    -- 2. 选自己额外卡组表侧表示最多 ct 张卡送去墓地（下限1）
    local exg_faceup = Duel.GetFieldGroup(tp, LOCATION_EXTRA, 0):Filter(Card.IsFaceup, nil)
    if #exg_faceup > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        local sg2 = exg_faceup:Select(tp, 1, ct, nil)
        if sg2 and #sg2 > 0 then
            success_send = Duel.SendtoGrave(sg2, REASON_EFFECT)
        end
    end

    -- 3. 回收墓地（下限1）
    local op_count = success_destroy + success_send
    if op_count > 0 then
        local mg = Duel.GetMatchingGroup(Card.IsAbleToDeck, tp, LOCATION_GRAVE, 0, nil, nil)
        if #mg > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
            local tg = mg:Select(tp, 1, op_count, nil)
            if #tg > 0 then
                Duel.BreakEffect()
                Duel.SendtoDeck(tg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
            end
        end
    end
end