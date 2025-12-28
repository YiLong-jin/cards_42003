--决意预言者·露妮

local s,id,o=GetID()
function s.initial_effect(c)
	-- 效果①：召唤/特殊召唤时前进回合（从e3开始）
	local e3=Effect.CreateEffect(c)  -- 改为e3
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,99971070)
	local e4=e3:Clone()  -- 改为e4
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.advtg)
	e3:SetOperation(s.advop)
		e4:SetCountLimit(1,99971070)
	e4:SetTarget(s.advtg)
	e4:SetOperation(s.advop)
	c:RegisterEffect(e3)  -- 注册e3
	c:RegisterEffect(e4)  -- 注册e4
	
	
	
		
	
	-- 效果①：持续公开并等待5回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99971071)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
	
	
		--spsummon
		local e12=Effect.CreateEffect(c)
		e12:SetDescription(aux.Stringid(id,6))
		e12:SetType(EFFECT_TYPE_FIELD)
		e12:SetCode(EFFECT_SPSUMMON_PROC)
		e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e12:SetRange(LOCATION_HAND+LOCATION_DECK)
		e12:SetCountLimit(1,99971075)
		e12:SetCondition(s.pubcon1)
		c:RegisterEffect(e12)
		
			-- 特殊召唤时破坏对方怪兽效果（从e2开始）
	local e22=Effect.CreateEffect(c)  -- 改为e2
	e22:SetDescription(aux.Stringid(id,3))
	e22:SetCategory(CATEGORY_DESTROY)
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	e22:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
			e22:SetCondition(s.pubcon2)
	e22:SetTarget(s.destg)
	e22:SetOperation(s.desop)
	c:RegisterEffect(e22)  -- 注册e2
end
function s.pubcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971078)~=0
end
function s.pubcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971079)~=0 and Duel.GetFlagEffect(tp,99971075)==0
end
--------增幅开始咯
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971070)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971070,2))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971070)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971070,RESET_PHASE+PHASE_END,0,4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971070.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,4)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,4)
	c99971070[c]=e1
end
function c99971070.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971070)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971070,RESET_PHASE+PHASE_END,0,5-ct)
	if ct>=1 then
	-- 第1回合时赋予效果
	--spsummon
		Duel.RegisterFlagEffect(tp,99971078,nil,0,98)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971070,4))
	end
	if ct>=4 then
	-- 第10回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
	-- 特殊召唤时破坏对方怪兽效果（从e2开始）
		Duel.RegisterFlagEffect(tp,99971079,nil,0,98)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971070,5))
	
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971070)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971070)
		e:GetLabelObject():Reset()
	end
end



function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and Duel.IsExistingMatchingCard(c99971070.filter,tp,0x3f,0x3f,1,nil)  end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		Duel.RegisterFlagEffect(tp,99971075,RESET_PHASE+PHASE_END,0,1)
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971070.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971070.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end






















function c99971070.advtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971070.filter,tp,0x3f,0x3f,1,nil)  end
end
-- 效果②：回合前进
function c99971070.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971070))
end
function c99971070.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function s.advop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971070.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971070.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end





