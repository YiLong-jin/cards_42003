--无尽巫师·桃乐丝
local s,id,o=GetID()
function s.initial_effect(c)



 -- 特殊召唤效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,99971020)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)  -- 注册e2



	
	-- 效果①：持续公开并等待8回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99971021)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
		local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(id,2))
	e13:SetCategory(CATEGORY_DRAW)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	e13:SetProperty(EFFECT_FLAG_DELAY)
	e13:SetCondition(s.drcon)
	e13:SetTarget(s.drtg)
	e13:SetOperation(s.drop)
	c:RegisterEffect(e13)
	
end

-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971020)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971020,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971020)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971020,RESET_PHASE+PHASE_END,0,8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(s.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,8)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,8)
	c99971020[c]=e1
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971020)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971020,RESET_PHASE+PHASE_END,0,9-ct)
	if ct>=8 then
	-- 第9回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971020)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971020)
		Duel.RegisterFlagEffect(tp,99971029,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971020,5))
		e:GetLabelObject():Reset()
	end
end

-------------赋予效果----------
function c99971020.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971030))
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99971020.filter,tp,0x3f,0x3f,1,nil) and Duel.GetFlagEffect(tp,99971021)==0 and Duel.GetFlagEffect(tp,99971029)~=0
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local hand=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		return hand<6 and Duel.IsPlayerCanDraw(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local hand=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.RegisterFlagEffect(tp,99971021,RESET_PHASE+PHASE_END,0,1)
	if hand>=6 then return end
	
	local max_draw=6-hand
	local drawn_cards=Group.CreateGroup()
	
	for i=1,max_draw do
		local g1=Duel.GetDecktopGroup(tp,1)
		if #g1==0 then break end
		
		-- 抽卡前先确认卡组顶
		Duel.ConfirmDecktop(tp,1)
		local tc=g1:GetFirst()
		
		-- 检查是否为超凡世界卡
		if not tc:IsSetCard(0x67f) then
			Duel.Draw(tp,1,REASON_EFFECT)
			drawn_cards:AddCard(tc)
			break
		else
			Duel.Draw(tp,1,REASON_EFFECT)
			drawn_cards:AddCard(tc)
		end
		
		-- 检查手卡是否达到6张
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=6 then
			break
		end
	end
	
	-- 向对手展示抽到的所有卡
	if drawn_cards:GetCount()>0 then
	Duel.ConfirmCards(1-tp,drawn_cards)
	end
		----五次增幅
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971020.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=10
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971020.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end

function c99971020.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end





---------------特召------------------------------
function s.tdfilter(c)
	return c:IsSetCard(0x67f) and c:IsAbleToDeck()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
	
	-- 特殊召唤这张卡
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		-- 对象卡回到卡组
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end


















