--泰坦
--这个卡名规则上也当作「未来战」卡来使用
--←2 【灵摆】 2→
--这个卡名的灵摆效果1回合只能使用1次
--①：另一边的自己的灵摆区域有「未来战」卡存在的场合才能发动。从卡组把1张「未来战」灵摆卡加入手卡。
--【怪兽效果】
--这个卡名的①②的效果1回合各能使用1次，这张卡的效果发动的回合，自己不是「未来战」怪兽不能特殊召唤。
--①：这张卡召唤·特殊召唤成功的场合才能发动。从自己卡组·墓地选1只「未来战」机械族怪兽加入手卡。
--②：加入额外卡组的场合才能发动。从卡组选1只「未来战」机械族灵摆怪兽在自己的灵摆区域放置。

local s, id, o = GetID()

function s.initial_effect(c)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)

    aux.EnablePendulumAttribute(c)

    -- ★ 灵摆效果（没有自肃）
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pencon)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- 怪兽效果①：召唤成功（有自肃）
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1, id + 1)
    e2:SetCost(s.cost)
    e2:SetTarget(s.smtg)
    e2:SetOperation(s.smop)
    c:RegisterEffect(e2)

    -- 怪兽效果①：特殊召唤成功（有自肃）
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1, id + 1)
    e3:SetCost(s.cost)
    e3:SetTarget(s.smtg)
    e3:SetOperation(s.smop)
    c:RegisterEffect(e3)

    -- 怪兽效果②：加入额外卡组（有自肃）
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 2))
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_MOVE)
    e4:SetCountLimit(1, id + 2)
    e4:SetCost(s.cost)
    e4:SetCondition(s.excon)
    e4:SetTarget(s.extg)
    e4:SetOperation(s.exop)
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
    if pzone:GetCount() < 2 then return false end
    local other = pzone:GetFirst()
    if other == c then other = pzone:GetNext() end
    return other and other:IsSetCard(0x671)
end

function s.penfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end

function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

-- ============================================================
-- 怪兽效果①
-- ============================================================
function s.smfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end

function s.smtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.smfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.smop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.smfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

-- ============================================================
-- 怪兽效果②
-- ============================================================
function s.excon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
end

function s.exfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE) and not c:IsForbidden()
end

function s.extg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local pzone_space = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
        return pzone_space and Duel.IsExistingMatchingCard(s.exfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_SEARCH, nil, 1, tp, LOCATION_DECK)
end

function s.exop(e, tp, eg, ep, ev, re, r, rp)
    if not (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
        return
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
    local g = Duel.SelectMatchingCard(tp, s.exfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        local tc = g:GetFirst()
        Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
    end
end