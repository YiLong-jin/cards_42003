-- 牧羊人（字段 0x671 未来战，0x673 侵蚀体）
-- 灵摆刻度：12
-- 卡号：99951300
-- 衍生物卡号：99951380（攻3500/守3000）

local s, id, o = GetID()

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)


	-- ============================================================
	-- 灵摆①：检索侵蚀体 + 回收额外表侧
	-- ============================================================
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.pen1_tg)
	e1:SetOperation(s.pen1_op)
	c:RegisterEffect(e1)

	-- ============================================================
	-- 灵摆②：生衍生物 → 这张卡从P区特殊召唤
	-- ============================================================
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.pen2_tg)
	e2:SetOperation(s.pen2_op)
	c:RegisterEffect(e2)

	-- ============================================================
	-- 同调召唤条件
	-- ============================================================
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c, s.tuner_filter, nil, nil, s.nontuner_filter, 1, 99)

	-- ============================================================
	-- 怪兽①：同调召唤成功时生衍生物
	-- ============================================================
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1, id + 2)
	e3:SetCondition(s.syncon)
	e3:SetTarget(s.syn_tg)
	e3:SetOperation(s.syn_op)
	c:RegisterEffect(e3)

	-- ============================================================
	-- 怪兽②：康效果（衍生物攻击力永久下降1500）
	-- ============================================================
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 3))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1, id + 3)
	e4:SetCondition(s.negcon)
	e4:SetTarget(s.negtg)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)

	-- ============================================================
	-- 怪兽③：场上有衍生物时离场 → 破坏全场 → 回P
	-- ============================================================
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 4))
	e5:SetCategory(CATEGORY_DESTROY)  
	e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1, id + 4)
	e5:SetCondition(s.leave_con)
	e5:SetTarget(s.leave_tg)
	e5:SetOperation(s.leave_op)
	c:RegisterEffect(e5)

	-- ============================================================
	-- 怪兽④：伤害计算时加攻（攻击力上升衍生物攻击力合计）
	-- ============================================================
	local e_atk = Effect.CreateEffect(c)
	e_atk:SetType(EFFECT_TYPE_SINGLE)
	e_atk:SetCode(EFFECT_UPDATE_ATTACK)
	e_atk:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e_atk:SetRange(LOCATION_MZONE)
	e_atk:SetCondition(function(e)
		local c = e:GetHandler()
		return Duel.GetCurrentPhase() == PHASE_DAMAGE_CAL
			and (Duel.GetAttacker() == c or Duel.GetAttackTarget() == c)
	end)
	e_atk:SetValue(function(e, c)
		local tp = c:GetControler()
		local tokens = Duel.GetMatchingGroup(Card.IsCode, tp, LOCATION_MZONE, 0, nil, 99951380)
		local total = 0
		for token in aux.Next(tokens) do
			total = total + token:GetAttack()
		end
		return total
	end)
	c:RegisterEffect(e_atk)
end

-- ============================================================
-- 同调素材筛选
-- ============================================================
function s.tuner_filter(c, syncard)
	return c:IsSetCard(0x671) and c:IsSynchroType(TYPE_SYNCHRO)
end

function s.nontuner_filter(c, syncard)
	return c:IsSetCard(0x671) and c:IsNotTuner(syncard) and c:IsSynchroType(TYPE_SYNCHRO)
end

-- ============================================================
-- 灵摆①
-- ============================================================
function s.pen1_filter(c)
	return c:IsSetCard(0x673) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.pen1_extra_filter(c)
	return c:IsFaceup() and c:IsSetCard(0x671) and c:IsAbleToHand()
end

function s.pen1_tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.pen1_filter, tp, LOCATION_DECK, 0, 1, nil)
			and Duel.IsExistingMatchingCard(s.pen1_extra_filter, tp, LOCATION_EXTRA, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 2, tp, LOCATION_DECK + LOCATION_EXTRA)
end

function s.pen1_op(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g1 = Duel.SelectMatchingCard(tp, s.pen1_filter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g1 > 0 then
		Duel.SendtoHand(g1, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g1)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g2 = Duel.SelectMatchingCard(tp, s.pen1_extra_filter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
	if #g2 > 0 then
		Duel.SendtoHand(g2, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g2)
	end
end

-- ============================================================
-- 流浪者衍生物创建（统一攻3500/守3000）
-- ============================================================
function s.create_wanderer(tp)
	local token = Duel.CreateToken(tp, 99951380)
	if not token then return nil end

	-- 等级12
	local e1 = Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(12)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e1, true)

	-- 种族机械族
	local e2 = Effect.CreateEffect(token)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_MACHINE)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e2, true)

	-- 属性暗
	local e3 = Effect.CreateEffect(token)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_DARK)
	e3:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e3, true)

	-- 攻击力3500
	local e4 = Effect.CreateEffect(token)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(3500)
	e4:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e4, true)

	-- 守备力3000
	local e5 = Effect.CreateEffect(token)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(3000)
	e5:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e5, true)

	return token
end

-- ============================================================
-- 流浪者衍生物效果注册（所有衍生物都有炸场+代破）
-- ============================================================
function s.register_wanderer_effects(token)
	-- 不能作为素材
	local e_mat1 = Effect.CreateEffect(token)
	e_mat1:SetType(EFFECT_TYPE_SINGLE)
	e_mat1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e_mat1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e_mat1:SetValue(1)
	e_mat1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e_mat1)

	local e_mat2 = e_mat1:Clone()
	e_mat2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e_mat2)

	local e_mat3 = e_mat1:Clone()
	e_mat3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	token:RegisterEffect(e_mat3)

	local e_mat4 = e_mat1:Clone()
	e_mat4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token:RegisterEffect(e_mat4)

	local e_mat5 = Effect.CreateEffect(token)
	e_mat5:SetType(EFFECT_TYPE_SINGLE)
	e_mat5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e_mat5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e_mat5:SetValue(1)
	e_mat5:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e_mat5)

	local e_mat6 = Effect.CreateEffect(token)
	e_mat6:SetType(EFFECT_TYPE_SINGLE)
	e_mat6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e_mat6:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	e_mat6:SetValue(1)
	e_mat6:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e_mat6)

	local e_mat7 = Effect.CreateEffect(token)
	e_mat7:SetType(EFFECT_TYPE_SINGLE)
	e_mat7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e_mat7:SetCode(EFFECT_UNRELEASABLE_NONSUM) 
	e_mat7:SetValue(1)
	e_mat7:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e_mat7)

	-- ★ 效果A：牧羊人离场 → 全场盖放并破坏
	local e7 = Effect.CreateEffect(token)
	e7:SetDescription(aux.Stringid(id, 5))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.wanderer_leave_con)
	e7:SetTarget(s.wanderer_leave_tg)
	e7:SetOperation(s.wanderer_leave_op)
	e7:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e7)

	-- ★ 效果B：代替破坏（守备力下降1500）
	local e_rep = Effect.CreateEffect(token)
	e_rep:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
	e_rep:SetCode(EFFECT_DESTROY_REPLACE)
	e_rep:SetRange(LOCATION_MZONE)
	e_rep:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk == 0 then
			local c = e:GetHandler()
			return eg:IsExists(s.rep_filter, 1, nil, tp)
				and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
				and c:GetDefense() >= 1500
		end
		return Duel.SelectYesNo(tp, aux.Stringid(id, 6))
	end)
	e_rep:SetValue(s.rep_value)
	e_rep:SetOperation(s.rep_operation)
	e_rep:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	token:RegisterEffect(e_rep)
end

-- ★ rep_filter：检查被破坏的是否是牧羊人（不限制破坏来源）
function s.rep_filter(c, tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsCode(id)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end

-- ★ rep_value：引擎询问“这个破坏是否可以被这个效果代替”
function s.rep_value(e, c)
	return s.rep_filter(c, e:GetHandlerPlayer())
end

-- ★ rep_operation：执行代替破坏的代价
function s.rep_operation(e, tp, eg, ep, ev, re, r, rp)
	local token = e:GetHandler()
	if not token or not token:IsLocation(LOCATION_MZONE) then return end

	local def = token:GetDefense()
	if def >= 1500 then
		local e1 = Effect.CreateEffect(token)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-1500)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		token:RegisterEffect(e1)
	else
		Duel.Destroy(token, REASON_EFFECT)
	end
end

-- ============================================================
-- 衍生物炸场效果
-- ============================================================
function s.wanderer_leave_con(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(Card.IsCode, 1, nil, id)
end

function s.wanderer_leave_tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 0, 0, LOCATION_ONFIELD)
end

function s.wanderer_leave_op(e, tp, eg, ep, ev, re, r, rp)
	-- 获取双方场上所有卡，排除灵摆区
	local g = Duel.GetMatchingGroup(function(c)
		return c:IsOnField() and not c:IsLocation(LOCATION_PZONE)
	end, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	
	if #g == 0 then return end

	-- 先盖放
	Duel.ChangePosition(g, POS_FACEDOWN_DEFENSE, POS_FACEDOWN_DEFENSE, POS_FACEDOWN_DEFENSE, POS_FACEDOWN_DEFENSE)

	-- 再破坏盖放的卡
	local fd = g:Filter(Card.IsFacedown, nil)
	if #fd > 0 then
		Duel.Destroy(fd, REASON_EFFECT)
	end
end

-- ============================================================
-- 怪兽③：离场条件
-- ============================================================
function s.leave_con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 99951380)
end

function s.leave_tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1))
	end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 0, 0, LOCATION_ONFIELD)
end

function s.leave_op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()

	-- 1. 获取场上所有卡（排除灵摆区）
	local g = Duel.GetMatchingGroup(function(card)
		return card:IsOnField() and not card:IsLocation(LOCATION_PZONE)
	end, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)

	-- 2. 盖放（非灵摆区）
	if #g > 0 then
		Duel.ChangePosition(g, POS_FACEDOWN_DEFENSE, POS_FACEDOWN_DEFENSE, POS_FACEDOWN_DEFENSE, POS_FACEDOWN_DEFENSE)
		-- 3. 破坏盖放的卡
		local fd = g:Filter(Card.IsFacedown, nil)
		if #fd > 0 then
			Duel.Destroy(fd, REASON_EFFECT)
		end
	end

	-- 4. 回P区（不变）
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then
		Duel.MoveToField(c, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
	end
end

-- ============================================================
-- 灵摆②
-- ============================================================
function s.pen2_tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
end

function s.pen2_op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local token = s.create_wanderer(tp)
	if token and Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		s.register_wanderer_effects(token)
	end
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end

-- ============================================================
-- 怪兽①
-- ============================================================
function s.syncon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.syn_tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
	end
	Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
end

function s.syn_op(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 1 then return end
	local token = s.create_wanderer(tp)
	if token and Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		s.register_wanderer_effects(token)
	end
end

-- ============================================================
-- 怪兽②：康效果
-- ============================================================
function s.negcon(e, tp, eg, ep, ev, re, r, rp)
	return ep == 1 - tp and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 99951380)
end

function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 99951380)
	end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
end

function s.negop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.NegateActivation(ev) then
		local wg = Duel.GetMatchingGroup(Card.IsCode, tp, LOCATION_MZONE, 0, nil, 99951380)
		if #wg > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
			local tg = wg:Select(tp, 1, 1, nil)
			if #tg > 0 then
				local tc = tg:GetFirst()
				local e1 = Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-1500)
				e1:SetReset(RESET_EVENT + RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end