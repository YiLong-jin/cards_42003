local s, id, o = GetID()

function s.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local chain = Duel.GetCurrentChain() --连锁号
    local isch, cheg, chep, chev, chre, chr, chrp = Duel.CheckEvent(EVENT_CHAINING, true) --连锁信息（如果正在连锁）
    local b1 = isch and chre:IsHasType(TYPE_ACTIVATE) and Duel.IsChainNegatable(chev) --要么买定离手（cost已经被检查），要么正在连锁且连锁效果是卡片发动(魔陷)且可以无效
    local b2 = Duel.IsExistingMatchingCard(Card.IsFaceup, tp, 0, LOCATION_MZONE, 1, nil) --对面有表侧怪
    if chk == 0 then
        return (b1 or b2) and (not e:IsCostChecked() or Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil, REASON_COST)) --要么无票上车（复制效果没Cost Checked）要么手牌有卡可以丢
    end
    local op = aux.SelectFromOptions(tp, {b1, aux.Stringid(id, 0)}, {b2, aux.Stringid(id, 1)}) - 1 --选效果, 0-based
    if e:IsCostChecked() then --一定是玩家手动发动而不是复制效果
        Duel.DiscardHand(tp, aux.TRUE, 1, 1, REASON_COST + REASON_DISCARD, nil) --丢一张 支代价
    end
    e:SetLabel(op) --记录选项
    if op == 0 then --无效
        if e:IsCostChecked() then
            e:SetCategory(CATEGORY_NEGATE) --手动发动才给类别 复制康不着
        end
        Duel.SetOperationInfo(0, CATEGORY_NEGATE, cheg, 1, 0, 0) --无效
        e:SetLabel(chev + 2) --将连锁号+2, 错开0 1
    elseif op == 1 then --炸场子
        if e:IsCostChecked() then
            e:SetCategory(CATEGORY_DESTROY)
        end
        local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil) --对面所有表侧怪
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0) --炸弹宣言
    else
        e:SetLabel(nil) --不应该发生
    end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local op = e:GetLabel() --读选项
    if op == 1 then --炸场子
        local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, 0, LOCATION_MZONE, nil) --对面所有表侧怪
        if #g > 0 then
            Duel.Destroy(g, REASON_EFFECT) --炸掉
        end
    elseif op >= 2 then --无效
        local chain = e:GetLabel() - 2 --读连锁号
        Duel.NegateActivation(chain) --无效
    end
end
