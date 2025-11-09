--三角爆发
local s, id = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(3, id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	-- 在脚本加载时注册全局监听器
	if not s.registered_global then
		s.registered_global = true
		local ge1 = Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.record_reptile_link_summon)
		Duel.RegisterEffect(ge1, 0)
	end
end


s.reptile_link_summon_count = {}

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	
	local tc = g:GetFirst()
	
	if tc:IsControler(tp) then
		Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, tc, 1, 0, 0)
	else
		Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, tc, 1, 0, 0)
		Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1-tp, 800)
	end
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	if not tc or not tc:IsRelateToEffect(e) then return end
	local flag=true
	if tc:IsControler(tp) then
		-- 自己控制的效果：攻击力上升
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(Duel.GetFlagEffect(tp,id)*1000)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD)
		tc:RegisterEffect(e1)
		flag=false
	else
		-- 对方控制的效果：送去墓地并给与伤害
		if Duel.SendtoGrave(tc, REASON_EFFECT) ~= 0 and Duel.Damage(1-tp, 800, REASON_EFFECT)>0 then 
			flag=false
		end
	end
	if flag or not c:IsRelateToEffect(e) then return end 
	-- 使用BreakEffect分隔前后效果
	Duel.BreakEffect()

	-- 可选效果：解放自己场上1张卡，让这张卡回到手卡
	local g = Duel.GetMatchingGroup(Card.IsReleasableByEffect, tp, LOCATION_ONFIELD, 0, c)
	if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
		c:CancelToGrave()
		local sg = g:Select(tp, 1, 1, nil)
		if #sg > 0 and Duel.Release(sg, REASON_EFFECT) ~= 0 then
			Duel.SendtoHand(c, nil, REASON_EFFECT)
		end
	end
end
-- 辅助函数：记录爬虫类族连接怪兽特殊召唤次数
function s.record_reptile_link_summon(e, tp, eg, ep, ev, re, r, rp)
	local g = eg:Filter(Card.IsRace, nil, RACE_REPTILE):Filter(Card.IsType, nil, TYPE_LINK)
	if #g > 0 then
		for p=0,1 do
			if g:IsExists(Card.IsSummonPlayer,1,nil,p) then
				Duel.RegisterFlagEffect(p, id, 0, 0, 1)
			end
		end
	end
end
