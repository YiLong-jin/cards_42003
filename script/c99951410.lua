-- 狮鹫骑士 克莉丝蒂娜·布莱希特
-- 光属性 机械族 连接/灵摆/效果
-- ATK 1650 连接标记：←↙
-- 灵摆刻度：←3 【灵摆】 3→
-- 这个卡名规则上也当作「未来战」「制裁者」卡来使用。

local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    aux.AddLinkProcedure(c, s.matfilter, 2, 2)
    c:EnableReviveLimit()

    -- 灵摆效果：起跳
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.pen_tg)
    e1:SetOperation(s.pen_op)
    c:RegisterEffect(e1)

    -- 怪兽①：特殊召唤成功时，堆额外表侧制裁者 + 检索
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOEXTRA + CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.mon1_tg)
    e2:SetOperation(s.mon1_op)
    c:RegisterEffect(e2)

    -- 怪兽②：离场时3选1
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCountLimit(1, id + 2)
    e3:SetTarget(s.mon2_tg)
    e3:SetOperation(s.mon2_op)
    c:RegisterEffect(e3)
end

function s.matfilter(c)
    return c:IsSetCard(0x671)
end

-- ============================================================
-- 灵摆效果
-- ============================================================
function s.pen_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.pen_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
end

-- ============================================================
-- 怪兽①
-- ============================================================

function s.mon1_extra_filter(c)
    return c:IsSetCard(0x672) and c:IsAbleToExtra()
end

function s.mon1_search_filter(c)
    return c:IsCode(99951420, 99951430)
        or (c:IsSetCard(0x672) and c:IsType(TYPE_MONSTER))
end

function s.mon1_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.mon1_extra_filter, tp, LOCATION_DECK, 0, 1, nil)
            and Duel.IsExistingMatchingCard(s.mon1_search_filter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, nil, 1, tp, LOCATION_DECK)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.mon1_op(e, tp, eg, ep, ev, re, r, rp)
    -- ①：从卡组把1张制裁者卡加入额外表侧
    local g1 = Duel.GetMatchingGroup(s.mon1_extra_filter, tp, LOCATION_DECK, 0, nil)
    if #g1 > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 6))
        local sg1 = g1:Select(tp, 1, 1, nil)
        if #sg1 > 0 then
            Duel.SendtoExtraP(sg1, tp, REASON_EFFECT)
        end
    end

    -- ②：检索「格里芬战线」「告别达那贝林」或制裁者怪兽
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g2 = Duel.SelectMatchingCard(tp, s.mon1_search_filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g2 > 0 then
        Duel.SendtoHand(g2, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g2)
    end
end

-- ============================================================
-- 怪兽②
-- ============================================================
function s.mon2_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local opt1 = Duel.IsExistingMatchingCard(function(c)
            return c:IsSetCard(0x671) and c:IsAbleToHand()
        end, tp, LOCATION_DECK, 0, 1, nil)
        local opt2 = Duel.IsExistingMatchingCard(function(c)
            return c:IsSetCard(0x672) and c:IsCanBeSpecialSummoned(nil, 0, tp, false, false)
        end, tp, LOCATION_GRAVE, 0, 1, nil)
        local opt3 = (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))
        return opt1 or opt2 or opt3
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end

function s.mon2_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    local options = {}
    local opt_map = {}

    local has_opt1 = Duel.IsExistingMatchingCard(function(card)
        return card:IsSetCard(0x671) and card:IsAbleToHand()
    end, tp, LOCATION_DECK, 0, 1, nil)
    if has_opt1 then
        table.insert(options, aux.Stringid(id, 3))
        table.insert(opt_map, 1)
    end

    local has_opt2 = Duel.IsExistingMatchingCard(function(card)
        return card:IsSetCard(0x672) and card:IsCanBeSpecialSummoned(nil, 0, tp, false, false)
    end, tp, LOCATION_GRAVE, 0, 1, nil)
    if has_opt2 then
        table.insert(options, aux.Stringid(id, 4))
        table.insert(opt_map, 2)
    end

    local has_opt3 = (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))
    if has_opt3 then
        table.insert(options, aux.Stringid(id, 5))
        table.insert(opt_map, 3)
    end

    if #options == 0 then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPTION)
    local choice = Duel.SelectOption(tp, table.unpack(options))

    local selected = opt_map[choice + 1]

    if selected == 1 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local g = Duel.SelectMatchingCard(tp, function(card)
            return card:IsSetCard(0x671) and card:IsAbleToHand()
        end, tp, LOCATION_DECK, 0, 1, 1, nil)
        if #g > 0 then
            Duel.SendtoHand(g, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, g)
        end
    elseif selected == 2 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local g = Duel.SelectMatchingCard(tp, function(card)
            return card:IsSetCard(0x672) and card:IsCanBeSpecialSummoned(nil, 0, tp, false, false)
        end, tp, LOCATION_GRAVE, 0, 1, 1, nil)
        if #g > 0 then
            Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
        end
    elseif selected == 3 then
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
        end
    end
end