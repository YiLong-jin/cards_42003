local s, id, o = GetID()

function s.initial_effect(c)
    -- ============================================================
    -- ①效果：主效果
    -- ============================================================
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOEXTRA + CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- ============================================================
    -- ②效果：墓地存续，本家变机械族 + 回10LP
    -- ============================================================
    -- ②-1：本家也当作机械族使用
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ADD_RACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTargetRange(LOCATION_MZONE, 0)
    e2:SetTarget(function(e, c)
        return c:IsSetCard(0x671)
    end)
    e2:SetValue(RACE_MACHINE)
    c:RegisterEffect(e2)

    -- ②-2：每次自己特殊召唤机械族，回复10LP
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return tp == Duel.GetTurnPlayer() and eg:IsExists(Card.IsRace, 1, nil, RACE_MACHINE)
    end)
    e3:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        Duel.Recover(tp, 10, REASON_EFFECT)
    end)
    c:RegisterEffect(e3)
end

-- ============================================================
-- 对象筛选
-- ============================================================
function s.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x671) and c:IsAbleToExtra()
end

-- ============================================================
-- 发动条件（target）
-- 检查：场上有本家同调 + （墓地有原素材 OR 额外表侧有本家卡）
-- ============================================================
function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc)
    end

    if chk == 0 then
        local has_target = Duel.IsExistingTarget(s.filter, tp, LOCATION_MZONE, 0, 1, nil)
        if not has_target then return false end

        -- 检查墓地是否有原素材（这条路径不受大宇宙影响）
        local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_MZONE, 0, nil)
        for tc in aux.Next(g) do
            local mg = tc:GetMaterial()
            if mg:Filter(s.matfilter, nil, e, tp, tc):GetCount() > 0 then
                return true
            end
        end

        -- 检查额外表侧是否有本家卡且能送去墓地
        if Duel.IsExistingMatchingCard(s.extra_filter, tp, LOCATION_EXTRA, 0, 1, nil) then
            local extra_g = Duel.GetMatchingGroup(s.extra_filter, tp, LOCATION_EXTRA, 0, nil)
            if extra_g:IsExists(Card.IsAbleToGrave, 1, nil) then
                return true
            end
        end

        return false
    end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, g, 1, 0, 0)
end

-- ============================================================
-- 素材筛选（必须是该同调怪兽的素材，且在墓地）
-- ============================================================
function s.matfilter(c, e, tp, sync)
    return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
        and bit.band(c:GetReason(), 0x80008) == 0x80008
        and c:GetReasonCard() == sync
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and aux.NecroValleyFilter()(c)
end

-- ============================================================
-- 额外补足筛选
-- ============================================================
function s.extra_filter(c)
    return c:IsFaceup() and c:IsSetCard(0x671)
end

-- ============================================================
-- 效果处理
-- ============================================================
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end

    local mg = tc:GetMaterial()
    local mat_count = mg:GetCount()
    if mat_count == 0 then return end

    -- 回额外
    if Duel.SendtoDeck(tc, nil, SEQ_DECKTOP, REASON_EFFECT) == 0 then return end
    if not tc:IsLocation(LOCATION_EXTRA) then return end
    if not tc:IsSummonType(SUMMON_TYPE_SYNCHRO) then return end

    -- 从墓地选原素材尽可能特殊召唤
    local grave_mats = mg:Filter(s.matfilter, nil, e, tp, tc)
    local summoned_group = Group.CreateGroup()
    local actual_summoned = 0

    if #grave_mats > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
        Duel.BreakEffect()
        local max_summon = math.min(#grave_mats, Duel.GetLocationCount(tp, LOCATION_MZONE))
        if max_summon > 0 then
            if #grave_mats > max_summon then
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
                local select_g = grave_mats:Select(tp, 1, max_summon, nil)
                if #select_g > 0 then
                    actual_summoned = Duel.SpecialSummon(select_g, 0, tp, tp, false, false, POS_FACEUP)
                    if actual_summoned > 0 then
                        summoned_group:Merge(select_g)
                    end
                end
            else
                actual_summoned = Duel.SpecialSummon(grave_mats, 0, tp, tp, false, false, POS_FACEUP)
                if actual_summoned > 0 then
                    summoned_group:Merge(grave_mats)
                end
            end
        end
    end

    -- 计算缺失素材数量（基于实际拉上来的数量）
    local not_summoned = mat_count - actual_summoned

    -- 从额外表侧补足缺失数量
    if not_summoned > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
        local extra_count = Duel.GetMatchingGroupCount(s.extra_filter, tp, LOCATION_EXTRA, 0, nil)
        if extra_count > 0 then
            local summon_count = math.min(not_summoned, extra_count, Duel.GetLocationCount(tp, LOCATION_MZONE))
            if summon_count > 0 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
                local g = Duel.SelectMatchingCard(tp, s.extra_filter, tp, LOCATION_EXTRA, 0, 1, summon_count, nil)
                if #g > 0 then
                    if Duel.SendtoGrave(g, REASON_EFFECT) > 0 then
                        local sg = g:Filter(Card.IsLocation, nil, LOCATION_GRAVE)
                        if #sg > 0 then
                            if Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP) > 0 then
                                summoned_group:Merge(sg)
                            end
                        end
                    end
                end
            end
        end
    end

    -- 如果没有成功苏生任何怪兽，结束
    if #summoned_group == 0 then return end

    -- ★ 检测苏生组中是否有本家同调怪兽
    local has_synchro = false
    for _, card in ipairs(summoned_group) do
        if card:IsSetCard(0x671) and card:IsType(TYPE_SYNCHRO) then
            has_synchro = true
            break
        end
    end
    if not has_synchro then return end

    -- 检测可用的召唤方式（不限本家）
    local sync_available = Duel.GetMatchingGroupCount(Card.IsSynchroSummonable, tp, LOCATION_EXTRA, 0, nil, nil) > 0
    local xyz_available = Duel.GetMatchingGroupCount(Card.IsXyzSummonable, tp, LOCATION_EXTRA, 0, nil, nil) > 0

    if not sync_available and not xyz_available then return end

    if not Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then return end

    Duel.BreakEffect()

    local choice = 0
    if sync_available and xyz_available then
        choice = Duel.SelectOption(tp, aux.Stringid(id, 2), aux.Stringid(id, 3))
    elseif sync_available then
        choice = 0
        Duel.SelectOption(tp, aux.Stringid(id, 2))
    else
        choice = 1
        Duel.SelectOption(tp, aux.Stringid(id, 3))
    end

    if choice == 0 then
        -- 同调召唤（不限本家）
        local g = Duel.GetMatchingGroup(Card.IsSynchroSummonable, tp, LOCATION_EXTRA, 0, nil, nil)
        if #g > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
            local sg = g:Select(tp, 1, 1, nil)
            if #sg > 0 then
                Duel.SynchroSummon(tp, sg:GetFirst(), nil)
            end
        end
    else
        -- 超量召唤（不限本家）
        local g = Duel.GetMatchingGroup(Card.IsXyzSummonable, tp, LOCATION_EXTRA, 0, nil, nil)
        if #g > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
            local sg = g:Select(tp, 1, 1, nil)
            if #sg > 0 then
                Duel.XyzSummon(tp, sg:GetFirst(), nil)
            end
        end
    end
end