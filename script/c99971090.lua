--万能的奇迹·梅露缇娜

local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x67f),2,2)
	c:EnableReviveLimit()
	-- 效果①：召唤/特殊召唤时检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99971090)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	e2:SetTarget(s.thtg1)
		e2:SetCountLimit(1,99971090)
	e2:SetOperation(s.thop1)
	c:RegisterEffect(e1)
	c:RegisterEffect(e2)
	
	
	-- 效果：破坏对方怪兽并回额外（从e3开始）
	local e3=Effect.CreateEffect(c)  -- 改为e3
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCountLimit(1,99971091)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)  -- 注册e3
		-- 1回合1次抽卡效果（从e1开始）
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(id,3))
	e14:SetCategory(CATEGORY_DRAW)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetRange(LOCATION_MZONE)
		e14:SetCondition(s.descon1)
	e14:SetCountLimit(1)
	e14:SetTarget(s.drtg)
	e14:SetOperation(s.drop)
	c:RegisterEffect(e14)
end

function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971099)~=0
end
-------------e3
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971090)==0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			if c:IsRelateToEffect(e) then
				Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
	
		if Duel.GetFlagEffect(tp,99971090)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971090,RESET_PHASE+PHASE_END,0,7)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971090.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,7)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,7)
	c99971090[c]=e1
			e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971090,2))
end
function c99971090.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971090)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971090,RESET_PHASE+PHASE_END,0,8-ct)
	if ct>=7 then
	-- 1回合1次抽卡效果（从e1开始）
		Duel.RegisterFlagEffect(tp,99971099,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971090,4))
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971090)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971090)
		e:GetLabelObject():Reset()
	end
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end








function c99971090.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971090))
end
function c99971090.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
-- 效果①：检索超凡世界卡
function s.thfilter1(c)
	return c:IsSetCard(0x67f) and c:IsAbleToHand()
end

function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c99971090.filter,tp,0x3f,0x3f,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g1>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971090.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971090.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end