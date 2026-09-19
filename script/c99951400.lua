-- 未来战·再循环
-- 永续魔法

local s, id, o = GetID()

function s.initial_effect(c)
    -- ①效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOGRAVE + CATEGORY_TOEXTRA)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate_op)
    c:RegisterEffect(e1)

    -- ②效果
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.search_tg)
    e2:SetOperation(s.search_op)
    c:RegisterEffect(e2)

    -- ③效果
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1, id + 2)
    e3:SetTarget(s.destroy_tg)
    e3:SetOperation(s.destroy_op)
    c:RegisterEffect(e3)
end

-- ============================================================
-- ①效果
-- ============================================================

function s.monster_filter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end

function s.extra_filter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end

function s.activate_op(e, tp, eg, ep, ev, re, r, rp)
    -- ①-1：可以从卡组把1只本家灵摆怪兽送去墓地
    local g1 = Duel.GetMatchingGroup(s.monster_filter, tp, LOCATION_DECK, 0, nil)
    if #g1 > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        local sg1 = g1:Select(tp, 1, 1, nil)
        if #sg1 > 0 then
            Duel.SendtoGrave(sg1, REASON_EFFECT)
        end
    end

    -- ①-2：从墓地选1只本家怪兽回到额外表侧（强制）
    local g2 = Duel.GetMatchingGroup(s.extra_filter, tp, LOCATION_GRAVE, 0, nil)
    if #g2 > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 5))
        local sg2 = g2:Select(tp, 1, 1, nil)
        if #sg2 > 0 then
            Duel.SendtoExtraP(sg2, tp, REASON_EFFECT)
        end
    end
end

-- ============================================================
-- ②效果
-- ============================================================

function s.search_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.search_op(e, tp, eg, ep, ev, re, r, rp)
    local hand = Duel.GetFieldGroup(1 - tp, LOCATION_HAND, 0)
    if #hand == 0 then return end

    local rg = hand:RandomSelect(tp, 1)
    if #rg == 0 then return end
    local tc = rg:GetFirst()
    if not tc then return end

    -- 展示给双方确认
    Duel.ConfirmCards(tp, rg)
    Duel.ConfirmCards(1 - tp, rg)

    local code = tc:GetOriginalCode()

    local same = Duel.GetMatchingGroup(function(c)
        return c:GetOriginalCode() == code and c:IsAbleToHand()
    end, tp, LOCATION_DECK, 0, nil)

    if #same > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local sg = same:Select(tp, 1, 1, nil)
        if #sg > 0 then
            Duel.SendtoHand(sg, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, sg)
        end
    else
        local future = Duel.GetMatchingGroup(function(c)
            return c:IsSetCard(0x671) and c:IsAbleToHand()
        end, tp, LOCATION_DECK, 0, nil)
        if #future > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
            local fg = future:Select(tp, 1, 1, nil)
            if #fg > 0 then
                Duel.SendtoHand(fg, nil, REASON_EFFECT)
                Duel.ConfirmCards(1 - tp, fg)
            end
        end
    end

    -- ★ 洗切对方手牌
    Duel.ShuffleHand(1 - tp)
end

-- ============================================================
-- ③效果
-- ============================================================

function s.destroy_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(function(c)
            return c:IsSetCard(0x671) and c:IsAbleToHand()
        end, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.destroy_op(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(function(c)
        return c:IsSetCard(0x671) and c:IsAbleToHand()
    end, tp, LOCATION_DECK, 0, nil)
    if #g > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local sg = g:Select(tp, 1, 1, nil)
        if #sg > 0 then
            Duel.SendtoHand(sg, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, sg)
        end
    end
end