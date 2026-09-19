local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY + CATEGORY_TOHAND + CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsSetCard(0x675) and c:IsType(TYPE_MONSTER)
		   and (c:GetLevel() == 6 or c:GetLevel() == 7 or c:GetLevel() == 9)
end

-- 9星可用：需要场上有「未来战」怪兽
function s.lv9_available(tp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard, tp, LOCATION_MZONE, 0, 1, nil, 0x671)
end

-- 7星可用：需要墓地有「未来战」怪兽
function s.lv7_available(tp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard, tp, LOCATION_GRAVE, 0, 1, nil, 0x671)
end

-- ★ 6星可用：使用自定义筛选，确保对方场上有表侧表示的卡
function s.lv6_available(tp)
	return Duel.IsExistingMatchingCard(s.lv6_filter, 1-tp, LOCATION_ONFIELD, 1, 1, nil)
end

function s.lv6_filter(c)
	return c:IsFaceup()  -- 只检查表侧表示的卡，更严格
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local exg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_EXTRA, 0, nil)
		if #exg == 0 then return false end
		return s.lv9_available(tp) or s.lv7_available(tp) or s.lv6_available(tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, tp, LOCATION_GRAVE)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 0, tp, LOCATION_ONFIELD)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 0, 1 - tp, LOCATION_ONFIELD)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local function available_filter(c)
		if not s.filter(c) then return false end
		local lv = c:GetLevel()
		if lv == 9 then return s.lv9_available(tp) end
		if lv == 7 then return s.lv7_available(tp) end
		if lv == 6 then return s.lv6_available(tp) end
		return false
	end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local g = Duel.SelectMatchingCard(tp, available_filter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
	if #g == 0 then return end
	local tc = g:GetFirst()
	Duel.ConfirmCards(1 - tp, tc)

	local lv = tc:GetLevel()
	if lv == 9 then
		s.lv9effect(e, tp)
	elseif lv == 7 then
		s.lv7effect(e, tp)
	elseif lv == 6 then
		s.lv6effect(e, tp)
	end
end

-- ---------- 9星效果 ----------
function s.lv9effect(e, tp)
	-- 对方只能攻击/选择「六翼」怪兽
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetTargetRange(0, LOCATION_MZONE)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)

	local e2 = Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2:SetTargetRange(0, LOCATION_MZONE)
	e2:SetValue(s.atkval)
	e2:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e2, tp)

	local e3 = Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetTarget(s.etarget)
	e3:SetValue(aux.tgoval)
	e3:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e3, tp)

	-- 那之后：保护1只未来战
	local g2 = Duel.GetMatchingGroup(Card.IsSetCard, tp, LOCATION_MZONE, 0, nil, 0x671)
	if #g2 > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
		local tg = g2:Select(tp, 1, 1, nil)
		if #tg > 0 then
			local tc = tg:GetFirst()
			local e4 = Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end

function s.atkval(e, c)
	return c:IsSetCard(0x675)
end

function s.etarget(e, c)
	return not c:IsSetCard(0x675)
end

-- ---------- 7星效果 ----------
function s.lv7effect(e, tp)
	local g1 = Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter), tp, LOCATION_GRAVE, 0, nil, e, tp)
	if #g1 > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local sg = g1:Select(tp, 1, 1, nil)
		if #sg > 0 then
			local tc = sg:GetFirst()
			if Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
				-- ★ 合并自己+对方场上的卡，强制选1～2张
				local dg = Group.CreateGroup()
				local all_cards = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_ONFIELD, 0, nil)
				-- 排除自身
				local filter = function(c) return c ~= e:GetHandler() end
				all_cards = all_cards:Filter(filter, nil)
				
				if #all_cards > 0 then
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
					local sg_all = all_cards:Select(tp, 1, 2, nil)  -- ★ 强制选1～2张
					if #sg_all > 0 then
						dg:Merge(sg_all)
					end
				end

				if #dg > 0 then
					Duel.HintSelection(dg)
					Duel.Destroy(dg, REASON_EFFECT)
				end
			end
		end
	end
end

function s.spfilter(c, e, tp)
	return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER)
		   and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

-- ---------- 6星效果 ----------
function s.lv6effect(e, tp)
	-- ★ 再次严格检查对方场上是否有表侧表示的卡
	local g = Duel.GetMatchingGroup(s.lv6_filter, 1-tp, LOCATION_ONFIELD, nil)
	if #g == 0 then return end

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RTOHAND)
	local sg = g:Select(tp, 1, 1, nil)
	if #sg > 0 then
		-- ★ 回手成功才执行堆墓
		if Duel.SendtoHand(sg, nil, REASON_EFFECT) ~= 0 then
			Duel.ConfirmCards(1 - tp, sg)
			Duel.SendtoGrave(Duel.GetDecktopGroup(tp, 3), REASON_EFFECT)
		end
	end
end