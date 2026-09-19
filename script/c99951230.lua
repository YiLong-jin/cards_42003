-- 埃斯塔科094
-- 这个卡名规则上也当作「未来战」卡来使用
-- ←5 【灵摆】 5→
-- 这个卡名的灵摆效果1回合只能使用1次
-- ①：另一边的自己的灵摆区没有卡存在的场合可以发动。将这张卡破坏，从卡组将1只的「未来战」机械族怪兽加入手牌。
-- 【怪兽效果】
-- 这个卡名的①②的效果1回合各能使用1次，这张卡的效果发动的回合，自己不是「未来战」怪兽不能特殊召唤。
-- ①：这张卡召唤·特殊召唤成功的场合才能发动。从卡组把1只「未来战」卡送去墓地。
-- ②：这张卡在额外卡组表侧存在的场合才能发动。从自己额外卡组表侧选1只「未来战」怪兽加入手卡，这张卡特殊召唤。

local s, id, o = GetID()

function s.initial_effect(c)
    -- ★ 添加自定义活动计数器（自肃用）
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)

    aux.EnablePendulumAttribute(c)

    -- ========== 灵摆效果 ==========
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_SEARCH + CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pencon)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- ========== 怪兽效果①：堆墓 ==========
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1, id + 1)
    e2:SetCost(s.cost)  -- ★ 添加自肃cost
    e2:SetTarget(s.gvtg)
    e2:SetOperation(s.gvop)
    c:RegisterEffect(e2)

    local e3 = e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)

    -- ========== 怪兽效果②：额外回收+特召 ==========
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 2))
    e4:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1, id + 2)
    e4:SetCondition(s.spcon2)
    e4:SetCost(s.cost)  -- ★ 添加自肃cost
    e4:SetTarget(s.sptg2)
    e4:SetOperation(s.spop2)
    c:RegisterEffect(e4)
end

-- ============================================================
-- ★ 自肃相关函数
-- ============================================================

function s.counterfilter(c)
    return c:IsSetCard(0x671) and c:IsFaceup()
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) == 0
    end
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
    e1:SetTargetRange(1, 0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, tp)
end

function s.splimit(e, c, sump, sumtype, sumpos, targetp, se)
    return not c:IsSetCard(0x671)
end

-- ============================================================
-- 灵摆效果
-- ============================================================
function s.pencon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local pzone = Duel.GetFieldGroup(tp, LOCATION_PZONE, 0)
    if pzone:GetCount() < 2 then
        return true
    end
    local other = pzone:GetFirst()
    if other == c then other = pzone:GetNext() end
    return other == nil or not other:IsLocation(LOCATION_PZONE)
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.penfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if Duel.Destroy(c, REASON_EFFECT) == 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

-- ============================================================
-- 怪兽效果①：堆墓
-- ============================================================
function s.gvfilter(c)
    return c:IsSetCard(0x671) and c:IsAbleToGrave()
end

function s.gvtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.gvfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.gvop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.gvfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoGrave(g, REASON_EFFECT)
    end
end

-- ============================================================
-- 怪兽效果②：额外回收+特召
-- ============================================================
function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end

function s.spfilter2(c, except)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c ~= except and c:IsAbleToHand()
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local exg = Duel.GetFieldGroup(tp, LOCATION_EXTRA, 0):Filter(Card.IsFaceup, nil)
    local tg = exg:Filter(s.spfilter2, nil, c)

    if chk == 0 then
        return #tg > 0 and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, tg, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()

    local exg = Duel.GetFieldGroup(tp, LOCATION_EXTRA, 0):Filter(Card.IsFaceup, nil)
    local tg = exg:Filter(s.spfilter2, nil, c)
    if #tg == 0 then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local sg = tg:Select(tp, 1, 1, nil)
    if #sg > 0 then
        Duel.SendtoHand(sg, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, sg)
    end

    if c:IsRelateToEffect(e) and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0 then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end