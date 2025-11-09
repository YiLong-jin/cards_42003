--星鼻鼹鼠
local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5fe0) and c:IsFaceup() and c:IsAbleToDeck()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then 
        return s.filter(chkc) and chkc:IsLocation(LOCATION_GRAVE + LOCATION_REMOVED) and chkc:IsControler(tp)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.filter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 3, nil)
    Duel.SetOperationInfo(0, CATEGORY_TODECK, g, #g, 0, 0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    if tg then
        local sg = tg:Filter(Card.IsRelateToEffect, nil, e):Filter(aux.NecroValleyFilter(aux.TRUE), nil)
        Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
    end
end