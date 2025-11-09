--三角波动

local s, id = GetID()

function s.initial_effect(c)
	
	-- 速攻魔法
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	
	-- 效果②：结束阶段墓地效果
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE + PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.counterfilter(c)
	return c:IsLevel(8) and c:IsType(TYPE_LINK)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(17418744,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
-- 特殊召唤限制
function s.splimit(e, c, tp)
	return not (c:IsLevel(8) or c:IsType(TYPE_LINK))
end

-- 效果①：检索目标
function s.thfilter(c)
	return c:IsCode(71100800, 71100814) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
		return g:GetClassCount(Card.GetCode) >= 2
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 2, tp, LOCATION_DECK)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	-- 检索两张卡
	local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
	if g:GetClassCount(Card.GetCode) >= 2 then
		local sg = Group.CreateGroup()
		
		-- 检索「不切实际的第一类接触」
		local tc1 = g:Filter(Card.IsCode, nil, 71100800):GetFirst()
		if tc1 then
			sg:AddCard(tc1)
		end
		
		-- 检索「三角冲击」
		local tc2 = g:Filter(Card.IsCode, nil, 71100814):GetFirst()
		if tc2 then
			sg:AddCard(tc2)
		end
		
		if sg:GetCount() == 2 then
			Duel.SendtoHand(sg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, sg)
		end
	end
end

-- 效果②：回到卡组目标
function s.tdfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsType(TYPE_LINK) and c:IsAbleToExtra()
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
		-- 必须至少有一张爬虫类族连接怪兽才能发动
		local rg = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE, 0, nil)
		return c:IsAbleToDeck() and rg:GetCount() > 0
	end

	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 2, 0, 0)
end

-- 效果②：回到卡组操作
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local g = Group.FromCards(c)
	local rg = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE, 0, nil)
	
	if rg:GetCount() > 0 then
		-- 重新选择要回到卡组的爬虫类族连接怪兽
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
		local sg = rg:Select(tp, 1, rg:GetCount(), nil)
		g:Merge(sg)
	else
		return 
	end
	
	if g:GetCount() > 1 then
		local ct = Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
		if ct > 0 and ct >= 3 then
			Duel.BreakEffect()
			Duel.Draw(tp, ct // 3, REASON_EFFECT)
		end
	end
end