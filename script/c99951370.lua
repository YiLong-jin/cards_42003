--俄罗斯娃娃
function c99951370.initial_effect(c)
	-- 发动时的效果处理（适用于永续魔法，处理完留在场上）
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c99951370.target)
	e1:SetOperation(c99951370.activate)
	c:RegisterEffect(e1)
	-- 注意：因为是永续魔法，没有其他持续效果，所有处理都在activate中完成
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,99951371)
	e2:SetTarget(c99951370.tdtg)
	e2:SetOperation(c99951370.tdop)
	c:RegisterEffect(e2)
end

-- 基础筛选：字段+灵摆类型+额外表侧
function c99951370.filter(c)
	if not (c:IsSetCard(0x671) and c:IsType(TYPE_PENDULUM)) then
		return false
	end
	if c:IsLocation(LOCATION_GRAVE) then
		return true   -- 墓地默认表侧
	elseif c:IsLocation(LOCATION_EXTRA) then
		return c:IsFaceup()   -- 额外必须表侧
	end
	return false
end

-- Target阶段：只检查是否存在至少一个合法对象
function c99951370.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local g = Duel.GetMatchingGroup(c99951370.filter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, nil)
		return g:GetCount() > 0
	end
end

-- Activate阶段：先选选项，再选怪兽
function c99951370.activate(e, tp, eg, ep, ev, re, r, rp)
	-- 1. 获取所有符合条件的怪兽
	local g_all = Duel.GetMatchingGroup(c99951370.filter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, nil)
	if g_all:GetCount() == 0 then
		return
	end

	-- 2. 询问是否适用效果（"可以"）
	if Duel.SelectYesNo(tp, aux.Stringid(99951370, 0)) == false then
		return
	end

	-- 3. 检查各选项是否可行（注意：每个选项都需要有至少一只怪兽能完成该操作）
	-- 加入手卡：只要有怪兽即可
	local has_hand = g_all:GetCount() > 0

	-- 灵摆区放置：P区有空位
	local has_place = (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))

	-- 特殊召唤：至少有一只怪兽能从其所在位置特殊召唤（满足位置条件）
	local has_sp = false
	for tc in aux.Next(g_all) do
		if tc:IsLocation(LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
				has_sp = true
				break
			end
		elseif tc:IsLocation(LOCATION_EXTRA) then
			if Duel.GetLocationCountFromEx(tp, tp, nil, tc) > 0 then
				has_sp = true
				break
			end
		end
	end

	-- 如果没有任何选项可行，直接返回（理论上target已保证至少有一个，但安全起见）
	if not (has_hand or has_place or has_sp) then
		return
	end

	-- 4. 构建可行的选项列表（只显示当前确实能执行的）
	local opts = {}
	local ops = {}
	if has_hand then
		table.insert(opts, aux.Stringid(99951370, 1))  -- "加入手卡"
		table.insert(ops, 1)
	end
	if has_place then
		table.insert(opts, aux.Stringid(99951370, 2))  -- "灵摆区放置"
		table.insert(ops, 2)
	end
	if has_sp then
		table.insert(opts, aux.Stringid(99951370, 3))  -- "特殊召唤"
		table.insert(ops, 3)
	end

	-- 5. 玩家选择选项
	local sel = Duel.SelectOption(tp, table.unpack(opts))
	local op = ops[sel + 1]

	-- 6. 根据所选选项，筛选可选的怪兽
	local g_select = nil
	if op == 1 then
		-- 加入手卡：所有符合基本条件的怪兽均可
		g_select = g_all
	elseif op == 2 then
		-- 灵摆区放置：所有符合基本条件的怪兽均可（P区已确认有空位）
		g_select = g_all
	elseif op == 3 then
		-- 特殊召唤：只选择来源有位置的怪兽
		local sp_filter = function(c)
			if not c99951370.filter(c) then return false end
			if c:IsLocation(LOCATION_GRAVE) then
				return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			elseif c:IsLocation(LOCATION_EXTRA) then
				return Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
			end
			return false
		end
		g_select = Duel.GetMatchingGroup(sp_filter, tp, LOCATION_GRAVE + LOCATION_EXTRA, 0, nil)
	end

	if not g_select or g_select:GetCount() == 0 then
		return
	end

	-- 7. 让玩家选择1只怪兽
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local sc = g_select:Select(tp, 1, 1, nil):GetFirst()
	if not sc then
		return
	end

	-- 8. 执行操作
	if op == 1 then
		Duel.SendtoHand(sc, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sc)
	elseif op == 2 then
		Duel.MoveToField(sc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
	elseif op == 3 then
		Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
	end
	-- 永续魔法处理完毕，留在场上
end

--e2
function c99951370.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end

function c99951370.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c99951370.tdfilter,tp,LOCATION_EXTRA,0,nil)
		return g:GetCount()>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,0)
end

function c99951370.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c99951370.tdfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		if sg:GetCount()==2 then
			sg:AddCard(c)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end