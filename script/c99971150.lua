--破式执行者·沙摩尔

local s,id,o=GetID()
function s.initial_effect(c)
	-- 不能特殊召唤

	
	-- 效果①：无效对方效果（从e2开始）
	local e2=Effect.CreateEffect(c)  -- 改为e2
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)  -- 注册e2
	
	
	
		
	-- 效果①：持续公开并等待5回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
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
			e12:SetCondition(s.pubcon1)
		e12:SetCountLimit(1,99971157)
		c:RegisterEffect(e12)
end
function s.pubcon1(e,c)
	if c==nil then return true end
		local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,99971159)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--------增幅开始咯
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971150)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971150,2))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971150)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971150,RESET_PHASE+PHASE_END,0,8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971150.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,8)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,8)
	c99971150[c]=e1
end
function c99971150.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971150)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971150,RESET_PHASE+PHASE_END,0,9-ct)
	if ct>=8 then
	-- 第3回合时赋予效果
	--spsummon
		Duel.RegisterFlagEffect(tp,99971159,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971150,4))

	
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971150)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971150)
		e:GetLabelObject():Reset()
	end
end






















function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end