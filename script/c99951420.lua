-- 格里芬战线
-- 速攻魔法
-- 99951420
-- 这个卡名的卡在1回合只能发动1张，这个卡名的②的效果1回合只能使用1次。
-- ①：指定对方场上1个主要怪兽区域才能发动。那个区域有表侧表示怪兽存在的场合，那只怪兽破坏。那之后，这个回合，对方不能使用那个区域。那个区域没有怪兽存在的场合，这个回合，对方不能使用那个区域。
-- ②：这张卡在墓地存在，对方把怪兽特殊召唤到①效果指定的区域以外的场合才能发动。这张卡回到手卡。那之后，从卡组把1张「未来战」卡送去墓地。

local s, id, o = GetID()

function s.initial_effect(c)
    -- ①效果
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    -- ②效果
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_TOHAND + CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, id + 1)
    e2:SetCondition(s.retcon)
    e2:SetTarget(s.rettg)
    e2:SetOperation(s.retop)
    c:RegisterEffect(e2)
end

-- ============================================================
-- ①效果
-- ============================================================
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        for seq = 0, 4 do
            if Duel.GetFieldCard(1 - tp, LOCATION_MZONE, seq) or Duel.CheckLocation(1 - tp, LOCATION_MZONE, seq) then
                return true
            end
        end
        return false
    end
    local dis = Duel.SelectField(tp, 1, 0, LOCATION_MZONE, 0)
    e:SetLabel(dis)
    Duel.Hint(HINT_ZONE, tp, dis)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local dis = e:GetLabel()
    if dis == 0 then return end
    local seq = -1
    for i = 0, 4 do
        if (dis >> (i + 16)) & 1 == 1 then
            seq = i
            break
        end
    end
    if seq < 0 then return end
    local zone =aux.SequenceToGlobal(1-tp,LOCATION_MZONE,seq)
    local tc = Duel.GetFieldCard(1 - tp, LOCATION_MZONE, seq)
    if tc and tc:IsFaceup() then
        Duel.Destroy(tc, REASON_EFFECT)
    end
    c:RegisterFlagEffect(id, RESET_PHASE + PHASE_END, 0, 1, 1 << seq)
    local e1 = Effect.CreateEffect(c)   
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE_FIELD)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(zone)
    e1:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, tp)
end

-- ============================================================
-- ②效果
-- ============================================================
function s.retcon(e, tp, eg, ep, ev, re, r, rp)
    local zone = e:GetHandler():GetFlagEffectLabel(id)
    if not zone then return false end

    for tc in aux.Next(eg) do
        -- ★ 检查“特殊召唤的玩家是对方”，而不是“控制者是对方”
        if tc:IsSummonPlayer(1 - tp) and tc:IsLocation(LOCATION_MZONE) then
            local seq = tc:GetSequence()
            if (zone & (1 << seq)) == 0 then
                return true
            end
        end
    end
    return false
end

function s.rettg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():IsAbleToHand()
            and Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.tgfilter(c)
    return c:IsSetCard(0x671) and c:IsAbleToGrave()
end

function s.retop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
        local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
        if #g > 0 then
            Duel.SendtoGrave(g, REASON_EFFECT)
        end
    end
end