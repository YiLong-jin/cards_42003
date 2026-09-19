-- 德蕾卡娃克259
local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- 同调召唤条件
    c:EnableReviveLimit()
    aux.AddSynchroMixProcedure(c, s.matfilter1, nil, nil, s.matfilter2, 1, 99)

    -- 灵摆效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.pen_tg)
    e1:SetOperation(s.pen_op)
    c:RegisterEffect(e1)

    -- ①效果 以前（这个卡名的以下效果1回合各能选择1次同一连锁上最多1次）
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, id+1)
    e2:SetCondition(s.con)
    e2:SetTarget(s.tg)
    e2:SetOperation(s.op)
    c:RegisterEffect(e2)

    -- ②效果
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1, id + 2)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

-- ============================================================
-- 同调召唤手续
-- ============================================================
function s.matfilter1(c)
    return c:IsSetCard(0x671) and c:IsSynchroType(TYPE_SYNCHRO)
end

function s.matfilter2(c, syncard)
    return c:IsSetCard(0x671) and c:IsNotTuner(syncard)
end

-- ============================================================
-- 灵摆效果
-- ============================================================
function s.pen_tg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then
        return Duel.IsExistingMatchingCard(Card.IsSetCard, tp, LOCATION_GRAVE, 0, 1, nil, 0x671)
            and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.pen_op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, Card.IsSetCard, tp, LOCATION_GRAVE, 0, 1, 1, nil, 0x671)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
    end
end

-- ============================================================
-- ①效果
-- ============================================================
function s.con(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetFlagEffect(tp, id) > 0 then
        return false
    end
    return re:GetHandler() ~= e:GetHandler()
end

function s.tg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        Duel.RegisterFlagEffect(tp, id, RESET_CHAIN, 0, 0)

        local chain1 = Duel.GetFlagEffect(tp, id + 1)
        local turn1 = Duel.GetFlagEffect(tp, id + 4)
        local opt1_available = (chain1 == 0) and (turn1 == 0)
        
        local chain2 = Duel.GetFlagEffect(tp, id + 2)
        local turn2 = Duel.GetFlagEffect(tp, id + 5)
        local opt2_available = (chain2 == 0) and (turn2 == 0)
        
        local chain3 = Duel.GetFlagEffect(tp, id + 3)
        local turn3 = Duel.GetFlagEffect(tp, id + 6)
        local opt3_available = (chain3 == 0) and (turn3 == 0)
        
        return opt1_available or opt2_available or opt3_available
    end
    Duel.SetOperationInfo(0, CATEGORY_DISABLE, eg, 1, 0, 0)
end

function s.op(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end

    local chain1 = Duel.GetFlagEffect(tp, id + 1)
    local turn1 = Duel.GetFlagEffect(tp, id + 4)
    local chain2 = Duel.GetFlagEffect(tp, id + 2)
    local turn2 = Duel.GetFlagEffect(tp, id + 5)
    local chain3 = Duel.GetFlagEffect(tp, id + 3)
    local turn3 = Duel.GetFlagEffect(tp, id + 6)

    local ops = {}
    local opval = {}
    
    if chain1 == 0 and turn1 == 0 then
        ops[#ops + 1] = aux.Stringid(id, 3)
        opval[#ops] = 1
    end
    if chain2 == 0 and turn2 == 0 then
        ops[#ops + 1] = aux.Stringid(id, 4)
        opval[#ops] = 2
    end
    if chain3 == 0 and turn3 == 0 then
        ops[#ops + 1] = aux.Stringid(id, 5)
        opval[#ops] = 3
    end

    if #ops == 0 then return end

    local op = Duel.SelectOption(tp, table.unpack(ops))
    local choice = opval[op + 1]

    if choice == 1 then
        Duel.RegisterFlagEffect(tp, id + 1, RESET_CHAIN, 0, 0)
        if Duel.GetFlagEffect(tp, id + 4) == 0 then
            Duel.RegisterFlagEffect(tp, id + 4, RESET_PHASE + PHASE_END, 0, 0)
        end
    elseif choice == 2 then
        Duel.RegisterFlagEffect(tp, id + 2, RESET_CHAIN, 0, 0)
        if Duel.GetFlagEffect(tp, id + 5) == 0 then
            Duel.RegisterFlagEffect(tp, id + 5, RESET_PHASE + PHASE_END, 0, 0)
        end
    elseif choice == 3 then
        Duel.RegisterFlagEffect(tp, id + 3, RESET_CHAIN, 0, 0)
        if Duel.GetFlagEffect(tp, id + 6) == 0 then
            Duel.RegisterFlagEffect(tp, id + 6, RESET_PHASE + PHASE_END, 0, 0)
        end
    end

    local e_limit = Effect.CreateEffect(c)
    e_limit:SetType(EFFECT_TYPE_FIELD)
    e_limit:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e_limit:SetTargetRange(0, 1)
    e_limit:SetReset(RESET_CHAIN)

    if choice == 1 then
        e_limit:SetCode(EFFECT_CANNOT_TO_HAND)
    elseif choice == 2 then
        e_limit:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    elseif choice == 3 then
        e_limit:SetCode(EFFECT_CANNOT_TO_GRAVE)
    end

    Duel.RegisterEffect(e_limit, tp)
end

-- ============================================================
-- ②效果（使用 EFFECT_LEAVE_FIELD_REDIRECT 实现离场回手）
-- ============================================================
function s.spfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_SPELL + TYPE_TRAP) and not c:IsType(TYPE_FIELD)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
            and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil)
            and Duel.IsPlayerCanSpecialSummonMonster(tp, 0, nil, 0x11, 0, 0, 0, 0, 0)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end

    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    if #g == 0 then return end
    local tc = g:GetFirst()

    if not Duel.IsPlayerCanSpecialSummonMonster(tp, tc:GetCode(), nil, 0x11, 0, 0, 0, 0, 0) then
        return
    end

    -- 变成怪兽
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(TYPE_SYNCHRO + TYPE_MONSTER)
    e1:SetReset(RESET_EVENT + 0x47c0000)
    tc:RegisterEffect(e1, true)

    local e2 = e1:Clone()
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(RACE_MACHINE)
    tc:RegisterEffect(e2, true)

    local e3 = e1:Clone()
    e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e3:SetValue(ATTRIBUTE_EARTH)
    tc:RegisterEffect(e3, true)

    local e4 = e1:Clone()
    e4:SetCode(EFFECT_SET_BASE_ATTACK)
    e4:SetValue(0)
    tc:RegisterEffect(e4, true)

    local e5 = e1:Clone()
    e5:SetCode(EFFECT_SET_BASE_DEFENSE)
    e5:SetValue(0)
    tc:RegisterEffect(e5, true)

    local e6 = e1:Clone()
    e6:SetCode(EFFECT_CHANGE_LEVEL)
    e6:SetValue(4)
    tc:RegisterEffect(e6, true)

    local e7 = e1:Clone()
    e7:SetCode(EFFECT_ADD_TYPE)
    e7:SetValue(TYPE_TUNER)
    tc:RegisterEffect(e7, true)

    -- 特殊召唤
    if Duel.SpecialSummon(tc, 0, tp, tp, true, false, POS_FACEUP) == 0 then return end

    -- ★ 离场时回到手卡（使用 EFFECT_LEAVE_FIELD_REDIRECT）
    local e_redirect = Effect.CreateEffect(e:GetHandler())
    e_redirect:SetType(EFFECT_TYPE_SINGLE)
    e_redirect:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e_redirect:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e_redirect:SetReset(RESET_EVENT + RESETS_REDIRECT)
    e_redirect:SetValue(LOCATION_HAND)
    tc:RegisterEffect(e_redirect, true)
end