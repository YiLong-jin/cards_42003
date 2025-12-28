--做作业啦！

local s,id,o=GetID()
function s.initial_effect(c)

	-- e2：主要效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,99971180)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
		
	-- 效果①：持续公开并等待5回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
	
	
	
		local e22=Effect.CreateEffect(c)
		e22:SetDescription(aux.Stringid(id,3))
	e22:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e22:SetType(EFFECT_TYPE_ACTIVATE)
	e22:SetCode(EVENT_FREE_CHAIN)
		e22:SetCondition(s.pubcon1)
	e22:SetTarget(s.target1)
	e22:SetOperation(s.activate1)
	c:RegisterEffect(e22)
end

function s.pubcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971189)==0
end
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971180)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971180,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971180)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971180,RESET_PHASE+PHASE_END,0,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971180.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,3)
	c99971180[c]=e1
end
function c99971180.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971180)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971180,RESET_PHASE+PHASE_END,0,4-ct)
	if ct>=3 then
	-- 第5回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971180)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971180)

	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.activate1)
	c:RegisterEffect(e2)

		Duel.RegisterFlagEffect(tp,99971189,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971180,5))
		e:GetLabelObject():Reset()
	end
end



function s.filter4(c)
	return c:IsSetCard(0x67f) and c:IsAbleToHand()
end

function s.filter24(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.filter24,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.IsExistingMatchingCard(c99971180.filter,tp,0x3f,0x3f,1,nil)
	end
end

function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	-- 搜索「超凡世界」卡
	local g1=Duel.GetMatchingGroup(s.filter4,tp,LOCATION_DECK,0,nil)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	
	-- 弹回对方魔法·陷阱卡
	local g2=Duel.GetMatchingGroup(s.filter24,tp,0,LOCATION_ONFIELD,nil)
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971180.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971180.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end









function c99971180.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971180))
end
function c99971180.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
-- 检查是否为「超凡世界」卡
function s.tdfilter(c)
	return c:IsSetCard(0x67f) and c:IsAbleToDeck()
end

function s.thfilter(c)
	return c:IsSetCard(0x67f) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 检查手卡是否有2张「超凡世界」卡可以返回卡组
		local handg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_HAND,0,nil)
		if #handg<1 then return false end
		
		-- 检查卡组是否有2张「超凡世界」卡可以加入手卡
		local deckg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		if #deckg<2 then return false end
		return true
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 检查手卡是否有2张「超凡世界」卡
	local handg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_HAND,0,e:GetHandler())
	if #handg<1 then return end
	
	-- 选择手卡2张「超凡世界」卡回到卡组
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tdg=handg:Select(tp,1,1,nil)
	if #tdg~=1 then return end
	
	Duel.ConfirmCards(1-tp,tdg)
	if Duel.SendtoDeck(tdg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=1 then return end
	
	-- 从卡组把2张「超凡世界」卡加入手卡
	local deckg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #deckg<2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=deckg:Select(tp,2,2,nil)
	if #thg~=2 then return end
	
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)
	Duel.ShuffleHand(tp)
	
	-- 选1张「超凡世界」卡的回合计算前进1回合
	Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971180.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971180.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end