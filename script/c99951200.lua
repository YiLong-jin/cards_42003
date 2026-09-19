local s, id, o = GetID()

function s.initial_effect(c)
    aux.EnablePendulumAttribute(c)

    -- 灵摆效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DESTROY)  -- ★ 只保留 DESTROY + SEARCH
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.pentg)
    e1:SetOperation(s.penop)
    c:RegisterEffect(e1)

    -- 怪兽效果①：手卡特召
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

    -- 怪兽效果②：召唤·特殊召唤成功时检索
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCountLimit(1, id + 2)
    e3:SetTarget(s.smtg)
    e3:SetOperation(s.smop)
    c:RegisterEffect(e3)

    local e4 = e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
end

-- ========== 灵摆效果 ==========
function s.pentg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.penfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)  -- ★ 只写 DESTROY
end

function s.penfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE) and not c:IsForbidden()
end

function s.penop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if Duel.Destroy(c, REASON_EFFECT) == 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)  -- ★ 用 TOFIELD
    local g = Duel.SelectMatchingCard(tp, s.penfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
        local tc = g:GetFirst()
        if Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1) then
            Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
        end
    end
end

-- ========== 怪兽效果① ==========
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_MZONE, 0, 1, c)
end

function s.spfilter(c)
    return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
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

-- ========== 怪兽效果② ==========
function s.smfilter(c)
    return c:IsSetCard(0x671)
        and (c:GetType() == TYPE_SPELL or c:GetType() == TYPE_TRAP or c:IsType(TYPE_CONTINUOUS))
        and c:IsAbleToHand()
end

function s.smtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.smfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end

function s.smop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.smfilter), tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end