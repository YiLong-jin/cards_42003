-- 特里亚纳计划泰坦211
-- 地属性 机械族 同调/灵摆/效果
-- ATK 2650 DEF 2000
-- 灵摆刻度：←8 【灵摆】 8→
-- 这个卡名规则上也当作「未来战」卡来使用

local s, id, o = GetID()

function s.initial_effect(c)
    -- === 同调召唤手续 ===
	aux.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
    c:EnableReviveLimit()
    
    -- === 灵摆基础 ===
    aux.EnablePendulumAttribute(c)
    
    -- === 灵摆效果：救援苏生 ===
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pzcon)
    e1:SetTarget(s.pztg)
    e1:SetOperation(s.pzop)
    c:RegisterEffect(e1)
    
    -- === 怪兽效果①：送墓额外2/4张 → 苏生墓地1/2只 ===
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOGRAVE + CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, id + 100)
    e2:SetTarget(s.mon1_tg)
    e2:SetOperation(s.mon1_op)
    c:RegisterEffect(e2)
    
    -- === 怪兽效果②：换P+破坏 ===
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE + LOCATION_EXTRA)
    e3:SetCountLimit(1, id + 2)
    e3:SetCondition(s.mon2_con)
    e3:SetTarget(s.mon2_tg)
    e3:SetOperation(s.mon2_op)
    c:RegisterEffect(e3)
    
    -- === 怪兽效果③：额外自跳（视为同调召唤） ===
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 3))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1, id + 3)
    e4:SetCondition(s.mon3_con)
    e4:SetTarget(s.mon3_tg)
    e4:SetOperation(s.mon3_op)
   c:RegisterEffect(e4)
end

-- ============================================================
-- 同调素材条件
-- ============================================================

function s.matfilter1(c)
	return c:IsSetCard(0x671)
end

-- ============================================================
-- 灵摆效果：救援苏生
-- ============================================================

function s.pzfilter(c, tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x671)
        and c:IsReason(REASON_BATTLE + REASON_EFFECT)
end

function s.pzcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.pzfilter, 1, nil, tp)
end

function s.pztg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local g = eg:Filter(s.pzfilter, nil, tp)
        return #g > 0 and Duel.GetLocationCount(tp, LOCATION_MZONE) >= #g + 1
            and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    local g = eg:Filter(s.pzfilter, nil, tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, #g, 0, 0)
end

function s.pzop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local g = eg:Filter(s.pzfilter, nil, tp)
    if #g == 0 then return end
    local sg = g:Filter(Card.IsCanBeSpecialSummoned, nil, e, 0, tp, false, false)
    if #sg > 0 then
        Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
    end
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- 怪兽效果①：送2拉1 / 送4拉2
-- ============================================================

function s.mon1_filter(c)
    return c:IsSetCard(0x671) and c:IsFaceup()
end

function s.mon1_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.mon1_filter, tp, LOCATION_EXTRA, 0, 2, nil)
    end
    
    local extra_count = Duel.GetMatchingGroupCount(s.mon1_filter, tp, LOCATION_EXTRA, 0, nil)
    local count = 2
    
    if extra_count >= 4 then
        Duel.Hint(HINT_SELECTMSG, tp, 0)
        count = Duel.AnnounceNumber(tp, 2, 4)
    end
    
    e:SetLabel(count)
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, count, tp, LOCATION_EXTRA)
end

function s.mon1_op(e, tp, eg, ep, ev, re, r, rp)
    local count = e:GetLabel()
    if count < 2 then return end
    
    -- 效果送墓
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.mon1_filter, tp, LOCATION_EXTRA, 0, count, count, nil)
    if #g < count then return end
    if Duel.SendtoGrave(g, REASON_EFFECT) == 0 then return end
    
    -- 检查墓地有没有可苏生的本家
    local grave_filter = function(c)
        return c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    local grave_count = Duel.GetMatchingGroupCount(grave_filter, tp, LOCATION_GRAVE, 0, nil)
    if grave_count == 0 then return end
    
    -- 用 SelectYesNo 询问玩家是否要拉怪
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 5)) then return end
    
    local max_sp = math.min(count // 2, Duel.GetLocationCount(tp, LOCATION_MZONE))
    if max_sp <= 0 then return end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg = Duel.SelectMatchingCard(tp, grave_filter, tp, LOCATION_GRAVE, 0, 1, max_sp, nil)
    if #sg > 0 then
        Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- 怪兽效果②：换P+破坏
-- ============================================================

function s.mon2_con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())
end

function s.mon2_filter(c)
    return c:IsSetCard(0x671) and c:IsFaceup()
end

function s.mon2_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.CheckLocation(tp, LOCATION_PZONE, 0) and Duel.CheckLocation(tp, LOCATION_PZONE, 1)
            and Duel.IsExistingMatchingCard(s.mon2_filter, tp, LOCATION_EXTRA, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, tp, LOCATION_PZONE)
end

function s.mon2_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    
    if not (Duel.CheckLocation(tp, LOCATION_PZONE, 0) and Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
        return
    end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
    local g = Duel.SelectMatchingCard(tp, s.mon2_filter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
    if #g == 0 then return end
    local tc = g:GetFirst()
    
    -- 先移动选中的卡到P区（左），再移动自己到P区（右）
    if not Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true) then return end
    if not Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true) then return end
    
    -- 破坏选中的卡（可选）
    if tc:IsLocation(LOCATION_PZONE) and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end

-- ============================================================
-- 怪兽效果③：额外自跳（视为同调召唤）
-- ============================================================

function s.mon3_con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end

function s.mon3_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local c = e:GetHandler()
        local filter = function(card)
            return card:IsSetCard(0x671) and card:IsFaceup() and card ~= c
        end
        return Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
            and Duel.IsExistingMatchingCard(filter, tp, LOCATION_EXTRA, 0, 2, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 2, tp, LOCATION_EXTRA)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.mon3_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local filter = function(card)
        return card:IsSetCard(0x671) and card:IsFaceup() and card ~= c
    end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, filter, tp, LOCATION_EXTRA, 0, 2, 2, nil)
    if #g < 2 then return end
    
    if Duel.SendtoGrave(g, REASON_EFFECT) == 0 then return end
    
    if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_EXTRA) then
        Duel.SpecialSummon(c, SUMMON_TYPE_SYNCHRO, tp, tp, false, true, POS_FACEUP)
        c:CompleteProcedure()
    end
end