-- 进化ONE163
-- 地属性 机械族 同调/灵摆/效果
-- 等级8 ATK 2800 DEF 2400
-- 灵摆刻度：←2 【灵摆】 2→
-- 这个卡名规则上也当作「未来战」卡来使用。

local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- 同调召唤手续
    aux.AddSynchroMixProcedure(c, s.matfilter1, nil, nil, aux.NonTuner(nil), 1, 99)
    c:EnableReviveLimit()

    -- 灵摆效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.pen_tg)
    e1:SetOperation(s.pen_op)
    c:RegisterEffect(e1)

    -- 怪兽①：特殊召唤成功时检索
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1, id + 1)
    e2:SetTarget(s.mon1_tg)
    e2:SetOperation(s.mon1_op)
    c:RegisterEffect(e2)

    -- ★ 怪兽②：永续效果（攻击表示时加攻 + 封锁）
    -- 攻击力上升
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.atk_condition)
    e3:SetValue(s.atk_value)
    c:RegisterEffect(e3)

    -- 怪兽②：战斗封锁（进行战斗的场合，对方不能发动效果）
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0, 1)
    e4:SetCondition(s.neg_condition)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end

function s.matfilter1(c)
    return c:IsSetCard(0x671)
end

-- ============================================================
-- 灵摆效果
-- ============================================================
function s.pen_filter(c, e, tp)
    return c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.pen_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.pen_filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
            and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end

function s.pen_op(e, tp, eg, ep, ev, re, r, rp)
    local self_lp = Duel.GetLP(tp)
    local opp_lp = Duel.GetLP(1 - tp)

    local count = 1
    if opp_lp > self_lp then
        local extra = math.floor((opp_lp - self_lp) / 2000)
        count = count + extra
    end

    local max_count = math.min(count, Duel.GetLocationCount(tp, LOCATION_MZONE))
    if max_count <= 0 then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.pen_filter, tp, LOCATION_GRAVE, 0, 1, max_count, nil, e, tp)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- 怪兽①
-- ============================================================
function s.mon1_search(c)
    return c:IsSetCard(0x671) and c:IsAbleToHand()
end

function s.mon1_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.mon1_search, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.mon1_op(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, s.mon1_search, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end

    local self_lp = Duel.GetLP(tp)
    local opp_lp = Duel.GetLP(1 - tp)
    if self_lp < opp_lp then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local rg = Duel.SelectMatchingCard(tp, function(c)
            return c:IsSetCard(0x671) and c:IsAbleToHand()
        end, tp, LOCATION_GRAVE, 0, 1, 1, nil)
        if #rg > 0 then
            Duel.SendtoHand(rg, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, rg)
        end
    end
end

-- ============================================================
-- ★ 怪兽②条件
-- ============================================================
function s.atk_condition(e)
    local c = e:GetHandler()
    return c:IsFaceup() and c:IsAttackPos()
end

function s.atk_value(e, c)
    local tp = c:GetControler()
    local self_lp = Duel.GetLP(tp)
    local opp_lp = Duel.GetLP(1 - tp)
    return math.max(0, opp_lp - self_lp)
end

-- ==========================================
-- 怪兽②：战斗封锁
-- ==========================================
function s.neg_condition(e)
    local c = e:GetHandler()
    return c:IsFaceup() and c:IsAttackPos() and (Duel.GetAttacker() == c or Duel.GetAttackTarget() == c)
end