--魔王-希斯克利夫
local s, id, o = GetID()

function s.initial_effect(c)
    -- 效果1
    local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0)) --给这个效果的描述设定成第一项
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON) --效果包含 检索 加手 召唤
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) --这张卡状态变化的时候，可以选发
	e1:SetProperty(EFFECT_FLAG_DELAY) --这张卡召唤·特殊召唤成功的"场合"（非时）
	e1:SetCode(EVENT_SUMMON_SUCCESS) --通常召唤成功时
	e1:SetCountLimit(1, id) --卡名1回合1次
    e1:SetCost(s.generalcost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.spsop)
	c:RegisterEffect(e2)
    --为每次玩家的召唤/通常召唤/特殊召唤（之中不符合s.counterfilter）的次数（最多为1）为CustomActivityCounter注册
    --i.e. 对于id为${id}的CustomActivityCounter, 如果对应玩家有执行过的话，就是1，否则是0
	Duel.AddCustomActivityCounter(id, ACTIVITY_SUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_NORMALSUMMON, s.counterfilter)
    Duel.AddCustomActivityCounter(id, ACTIVITY_SPSUMMON, s.counterfilter)
end

function s.counterfilter(c)
    --因为要给到从手牌卡组召唤特殊召唤的非暗属性怪兽 false返回值（给AddCustomActivityCounter捕捉), 所以符合 "不从手卡/卡组召唤"和"是暗属性怪兽"的这两个条件的其中之一要返回true
    --c:GetSummonLocation()返回了一个BitMask, 和(LOCATION_HAND|LOCATION_DECK)进行位和操作之后如果等于0则证明不是从这两个地方任意一个召唤
    return ((c:GetSummonLocation() & (LOCATION_HAND | LOCATION_DECK)) == 0) or c:IsAttribute(ATTRIBUTE_DARK)
end

function s.generalcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- 这张卡把效果发动的回合，自己不是暗属性怪兽不能从手卡·卡组召唤·特殊召唤。 的第一部分实现
        -- 如果玩家将非暗属性怪兽从卡组 手卡召唤 特殊召唤的话 效果将不能发动（Cost不能支付）
        return Duel.GetCustomActivityCount(id, tp, ACTIVITY_SUMMON) == 0 and Duel.GetCustomActivityCount(id, tp, ACTIVITY_NORMALSUMMON) == 0 and Duel.GetCustomActivityCount(id, tp, ACTIVITY_SPSUMMON) == 0
    end
    -- 这张卡把效果发动的回合，自己不是暗属性怪兽不能从手卡·卡组召唤·特殊召唤。 的第二部分实现
    -- 从支付完cost开始 玩家将不能进行上述操作
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH) --以玩家为对象&誓约效果
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) --不能特殊召唤
	e1:SetReset(RESET_PHASE + PHASE_END) --在回合结束时失效
	e1:SetTargetRange(1,0) --对自己生效
	e1:SetTarget(s.sumlimit) --对符合sumlimit的卡片不能召唤 特殊召唤
	Duel.RegisterEffect(e1, tp)
	local e2 = e1:Clone() --复制上一个效果
	e2:SetCode(EFFECT_CANNOT_SUMMON) --改为不能通常召唤
	Duel.RegisterEffect(e2, tp)
end

function s.sumlimit(e, c, sump, sumtype, sumpos, targetp, se)
    -- 只有满足以下两个条件的卡才会被禁止召唤
    -- 1. 现在在手牌或者卡组
    -- 2. 不是暗属性
    return c:IsLocation(LOCATION_HAND | LOCATION_DECK) and (not c:IsAttribute(ATTRIBUTE_DARK))
end

function s.searchfilter(c)
    -- 是呼啸山庄卡 以及可以加手
    return c:IsSetCard(0xafe4) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- 卡组里面至少有一张卡符合searchfilter, 否则不予发动
        return Duel.IsExistingMatchingCard(s.searchfilter, tp, LOCATION_DECK, 0, 1, nil)
    end
    -- 这个效果处理包含一张卡从玩家的卡组加手 （给灰流丽对应）
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
    -- 这个效果处理包含一个不确定的召唤
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 0, 0, 0)
end

function s.sumfilter(c)
	return c:IsSummonable(true, nil) and c:IsSetCard(0xafe4)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    -- 下一次玩家选择卡片的时候显示加手的提示信息
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    -- 玩家(参数1)从玩家(参数3)的卡组(参数4)中选择最少1张(参数6)最多1张(参数7)符合s.searchfilter(参数2)的卡
    local g = Duel.SelectMatchingCard(tp, s.searchfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        -- 加手
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        -- 给对手看
        Duel.ConfirmCards(1 - tp, g)
        -- 刚刚加手的卡是怪兽卡 且 玩家的手牌有符合s.sumfilter的卡 且 玩家在弹出的提示框选择进行追加召唤
        if g:GetFirst():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.sumfilter, tp, LOCATION_HAND, 0, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
            Duel.BreakEffect() -- 中断效果（会让时发效果错时点）
            Duel.ShuffleHand(tp) --洗手牌
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SUMMON) --下一次选卡的时候提示召唤
            local sg = Duel.SelectMatchingCard(tp, s.sumfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
			if sg:GetCount() > 0 then
				Duel.Summon(tp, sg:GetFirst(), true, nil) --追加召唤
			end
        end
    end
end

function s.spsop(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    while tc do
        if tc:IsSetCard(0xafe4) and tc ~= e:GetHandler() then
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_LEVEL)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(7)
            tc:RegisterEffect(e1)
        end
        tc = eg:GetNext()
    end
end