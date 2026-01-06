--雪人觉醒

local s,id,o=GetID()
function s.initial_effect(c)
	-- e2：主要效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,99971190)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	
	
	
	
	
	
	
	-- 效果①：持续公开并等待5回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99971193)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
	
	
		-- e2：主要效果
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(id,3))
	e22:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e22:SetType(EFFECT_TYPE_ACTIVATE)
	e22:SetCode(EVENT_FREE_CHAIN)
		e22:SetCountLimit(1,99971190)
		e22:SetCondition(s.pubcon1)
	e22:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e22:SetTarget(s.target)
	e22:SetOperation(s.activate1)
	c:RegisterEffect(e22)
end

function s.pubcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971199)~=0 and Duel.GetFlagEffect(tp,99971195)==0
end
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971190)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971190,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971190)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971190,RESET_PHASE+PHASE_END,0,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971190.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,3)
	c99971190[c]=e1
end
function c99971190.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971190)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971190,RESET_PHASE+PHASE_END,0,4-ct)
	if ct>=3 then
	-- 第5回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971190)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971190)

		Duel.RegisterFlagEffect(tp,99971199,nil,0,98)

		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971190,5))
		e:GetLabelObject():Reset()
	end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
		Duel.RegisterFlagEffect(tp,99971195,RESET_PHASE+PHASE_END,0,1)
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- 攻击力变为0
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
		-- 守备力变为0
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		-- 效果无效化（直到回合结束）
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		-- 显示提示
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
	end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971190.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971190.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end











function c99971190.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971190))
end
function c99971190.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function s.filter3(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c99971190.filter,tp,0x3f,0x3f,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter3,tp,0,LOCATION_MZONE,1,1,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		-- 攻击力变为0
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		
		-- 守备力变为0
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		
		-- 显示提示
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
	end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971190.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971190.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end