--黒之裁决者 七海莉雅
local s, id, o = GetID()

function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0x5fe0), 2, 127, false)

	if not s.global_check then
        s.global_check = true
        local ge1 = Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_FLIP)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1, 0)
    end
    local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1, 1)
	e1:SetValue(s.limval)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(s.settg)
    e2:SetOperation(s.setop)
    e2:SetCountLimit(1, id)
    c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)

    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_ACTIVATE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(1, 0)
    e4:SetValue(s.aclimit)
    c:RegisterEffect(e4)
end

function s.aclimit(e, re, tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x5fe0)
end

function s.checkop(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    while tc do
        tc:RegisterFlagEffect(id, RESET_EVENT+RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 1, aux.Stringid(id, 0))
        tc = eg:GetNext()
    end
end

function s.limval(e, re, rp)
    local rc = re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(id) > 0
end

function s.tgfilter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanTurnSet()
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
    local g = Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 4, nil)
    Duel.SetOperationInfo(0, CATEGORY_POSITION, g, #g, 0, 0)
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
    local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    if tg then
        local sg = tg:Filter(Card.IsRelateToEffect, nil, e):Filter(Card.IsLocation, nil, LOCATION_MZONE):Filter(Card.IsFaceup, nil)
        Duel.ChangePosition(sg, POS_FACEDOWN_DEFENSE)
    end
end

function s.tgtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local d = Duel.GetAttackTarget()
	if chk == 0 then return Duel.GetAttacker() == e:GetHandler() and d and d:IsDefensePos() end
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, d, 1, 0, 0)
end

function s.tgop(e, tp, eg, ep, ev, re, r, rp)
	local d = Duel.GetAttackTarget()
	if d:IsRelateToBattle() and d:IsDefensePos() then
	    Duel.SendtoGrave(d, REASON_EFFECT)
	end
end