--假期情怀
function c99940380.initial_effect(c)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99940380,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99940380+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99940380.targets)
	e1:SetOperation(c99940380.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99940380,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99940381)
	e2:SetCost(c99940380.cost)
	e2:SetTarget(c99940380.sptg)
	e2:SetOperation(c99940380.spop)
	c:RegisterEffect(e2)


end
function c99940380.filterss(c,e,tp)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940380.targets(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99940380.filterss,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99940380,2))
	e:SetLabel(Duel.AnnounceLevel(tp,1,10,nil))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99940380.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99940380.filterss,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		 local e3=Effect.CreateEffect(e:GetHandler())
		 e3:SetType(EFFECT_TYPE_SINGLE)
		 e3:SetCode(EFFECT_CHANGE_LEVEL)
		 e3:SetValue(e:GetLabel())
		 e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		 tc:RegisterEffect(e3,true)
		 local e2=Effect.CreateEffect(e:GetHandler())
		 e2:SetType(EFFECT_TYPE_SINGLE)
		 e2:SetCode(EFFECT_ADD_TYPE)
		 e2:SetValue(TYPE_TUNER)
		 e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		 tc:RegisterEffect(e2,true)
		end
end


-- ★ COST：墓地自身返回卡组（必须可返回）
function c99940380.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

-- ★ 攻击力1550的卡，且位于墓地 / 表侧灵摆区 / 表侧额外卡组
function c99940380.filter(c)
	return c:IsAttack(1550) --and c:IsType(TYPE_MONSTER)
		and (c:IsLocation(LOCATION_GRAVE)
			or (c:IsFaceup() and (c:IsLocation(LOCATION_PZONE) or c:IsLocation(LOCATION_EXTRA))))
end

-- ★ 判断能否特殊召唤（额外灵摆需要EX区/连接端）
function c99940380.can_sp_summon(c,e,tp)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) then
		return Duel.GetLocationCountFromEx(tp,tp,c)>0
	end
	return true
end

-- ★ 判断能否返回卡组（主卡组）
function c99940380.can_todeck(c)
	return c:IsAbleToDeck()
end

-- ★ 目标阶段：严格检查可行性
function c99940380.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 所有攻击力1550的候选（不要求能回卡组，因为特召卡不需要回卡组）
		local all=Duel.GetMatchingGroup(c99940380.filter,tp,LOCATION_GRAVE+LOCATION_PZONE+LOCATION_EXTRA,0,nil)
		if all:GetClassCount(Card.GetCode)<3 then return false end
		
		-- 必须存在一张可特召卡，且去掉同名后，仍有至少2种不同名且能返回卡组的卡
		local tc=all:GetFirst()
		while tc do
			if c99940380.can_sp_summon(tc,e,tp) then
				local remain=all:Clone()
				remain:Remove(Card.IsCode,nil,tc:GetCode())
				local todeck_ok=remain:Filter(c99940380.can_todeck,nil)
				if todeck_ok:GetClassCount(Card.GetCode)>=2 then
					return true
				end
			end
			tc=all:GetNext()
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_PZONE+LOCATION_EXTRA)
end

-- ★ 效果处理
function c99940380.spop(e,tp,eg,ep,ev,re,r,rp)
	-- 全部候选（不要求能回卡组，因为后面还要分开处理）
	local all=Duel.GetMatchingGroup(c99940380.filter,tp,LOCATION_GRAVE+LOCATION_PZONE+LOCATION_EXTRA,0,nil)
	if all:GetClassCount(Card.GetCode)<3 then return end
	
	-- 可特召的候选
	local sp_avail=all:Filter(c99940380.can_sp_summon,nil,e,tp)
	if sp_avail:GetCount()==0 then return end
	
	-- 第1步：玩家选择1张可特召卡（必须能特召）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local must_sp=sp_avail:Select(tp,1,1,nil):GetFirst()
	if not must_sp then return end
	local sg=Group.FromCards(must_sp)
	local code1=must_sp:GetCode()
	
	-- 剩余候选：除去同名卡，且必须能返回卡组（因为后面要选它们放回卡组底）
	local remain=all:Clone()
	remain:Remove(Card.IsCode,nil,code1)
	local todeck_avail=remain:Filter(c99940380.can_todeck,nil)
	if todeck_avail:GetClassCount(Card.GetCode)<2 then return end
	
	-- 第2步：玩家选择第2张卡（必须不同名，且能返回卡组）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=todeck_avail:Select(tp,1,1,nil)
	local tc2=g2:GetFirst()
	sg:AddCard(tc2)
	local code2=tc2:GetCode()
	todeck_avail:Remove(Card.IsCode,nil,code2)
	
	-- 第3步：玩家选择第3张卡（必须不同名，且能返回卡组）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=todeck_avail:Select(tp,1,1,nil)
	local tc3=g3:GetFirst()
	sg:AddCard(tc3)
	
	-- 此时sg包含3张不同名的卡，且must_sp可特召，另两张可返回卡组
	
	-- 第4步：玩家从sg中自由选择1只可特召的怪兽进行特殊召唤
	local sp_candidates=sg:Filter(c99940380.can_sp_summon,nil,e,tp)
	if sp_candidates:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spc=sp_candidates:Select(tp,1,1,nil):GetFirst()
	
	if Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	
	-- 第5步：剩余2张按玩家意愿顺序放回卡组最下面（这两张一定可返回卡组）
	sg:RemoveCard(spc)
	if sg:GetCount()~=2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local first=sg:Select(tp,1,1,nil):GetFirst()   -- 玩家希望这张卡成为最底部
	sg:RemoveCard(first)
	local second=sg:GetFirst()
	
	-- 正确顺序：后放的卡成为新的最底 → 先放second，再放first
	Duel.SendtoDeck(second,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	Duel.SendtoDeck(first,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
end