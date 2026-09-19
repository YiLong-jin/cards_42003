-- 告别达那贝林
-- 速攻魔法
-- 99951430
-- 这个卡名的卡在1回合只能发动1张，这个卡名的②的效果1回合只能使用1次。
-- ①：以对方场上1只怪兽为对象才能发动。那只怪兽回到手卡。那之后，从自己墓地选1只「未来战」怪兽特殊召唤。
-- ②：这张卡在墓地存在，自己把「未来战」怪兽特殊召唤的场合才能发动。这张卡回到卡组最下面，自己抽1张。

local s, id, o = GetID()

function s.initial_effect(c)
    -- ①效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1, id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- ②效果
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TODECK + CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, id + 1)
    e2:SetCondition(s.drawcon)
    e2:SetTarget(s.drawtg)
    e2:SetOperation(s.drawop)
    c:RegisterEffect(e2)
end

-- ============================================================
-- ①效果（参考「精神操作」写法）
-- ============================================================

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
            and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
    local g = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end

function s.spfilter(c, e, tp)
    return c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()

    -- ①-1：对方怪兽回到手卡
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc, nil, REASON_EFFECT)
    end

    -- ①-2：从墓地选1只本家怪兽特殊召唤
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- ②效果
-- ============================================================

function s.drawcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(function(c)
        return c:IsSetCard(0x671) and c:IsControler(tp)
    end, 1, nil)
end

function s.drawtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsAbleToDeck()
            and Duel.IsPlayerCanDraw(tp, 1)
    end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, tp, 1)
end

function s.drawop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c, nil, SEQ_DECKBOTTOM, REASON_EFFECT) > 0 then
        Duel.Draw(tp, 1, REASON_EFFECT)
    end
end