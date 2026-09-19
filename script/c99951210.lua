-- ATAC-130
local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- ========== 灵摆效果 ==========
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.pencon)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- ========== 怪兽效果①：手卡特召 ==========
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1, id + 1)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)

    -- ========== 怪兽效果②：被破坏时特召 ==========
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1, id + 2)
    e3:SetCondition(s.descon)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
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
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.penfilter(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    -- 1. 破坏自己
    if Duel.Destroy(c, REASON_EFFECT) == 0 then return end
    -- 2. 从卡组·墓地特召
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.penfilter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if #g > 0 then
        Duel.SpecialSummon(g:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- 怪兽效果①：场上有「未来战」怪兽时，从手卡特召
-- ============================================================
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.spfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
end

-- ============================================================
-- 怪兽效果②：被破坏时，从额外表侧或手卡特召
-- ============================================================
function s.descon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE + LOCATION_EXTRA)
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- 检查额外（表侧）是否有可特召的卡
        local has_extra = Duel.IsExistingMatchingCard(s.desfilter_extra, tp, LOCATION_EXTRA, 0, 1, nil, e, tp)
        -- 检查手卡是否有可特召的卡（排除自身，因为自身已被破坏）
        local has_hand = Duel.IsExistingMatchingCard(s.desfilter_hand, tp, LOCATION_HAND, 0, 1, nil, e, tp)
        return has_extra or has_hand
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA + LOCATION_HAND)
end

function s.desfilter_extra(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER)
        and c:IsFaceup() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
end

function s.desfilter_hand(c, e, tp)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c ~= e:GetHandler()
        and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
        and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local g_extra = Duel.GetMatchingGroup(s.desfilter_extra, tp, LOCATION_EXTRA, 0, nil, e, tp)
    local g_hand = Duel.GetMatchingGroup(s.desfilter_hand, tp, LOCATION_HAND, 0, nil, e, tp)
    
    local g = Group.CreateGroup()
    g:Merge(g_extra)
    g:Merge(g_hand)
    
    if #g == 0 then return end
    
    -- 如果只有一个来源有卡，直接选择；否则让玩家选择来源
    local sg = nil
    if #g_extra > 0 and #g_hand > 0 then
        -- 让玩家选择从额外还是手卡特召
        local opt = Duel.SelectOption(tp, 
            aux.Stringid(id, 3),  -- "额外卡组"
            aux.Stringid(id, 4)   -- "手卡"
        )
        if opt == 0 then
            sg = g_extra:Select(tp, 1, 1, nil)
        else
            sg = g_hand:Select(tp, 1, 1, nil)
        end
    elseif #g_extra > 0 then
        sg = g_extra:Select(tp, 1, 1, nil)
    elseif #g_hand > 0 then
        sg = g_hand:Select(tp, 1, 1, nil)
    end
    
    if sg and #sg > 0 then
        Duel.SpecialSummon(sg:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)
    end
end