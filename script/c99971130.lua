--唤鬼术

local s,id,o=GetID()
function s.initial_effect(c)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c99971130.target)
	e2:SetOperation(c99971130.activate)
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
	
	
		-- 效果①：特殊召唤暴鬼衍生物
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,2))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e12:SetType(EFFECT_TYPE_ACTIVATE)
	e12:SetCode(EVENT_FREE_CHAIN)
		e12:SetCondition(s.pubcon)
	e12:SetTarget(s.tktg3)
	e12:SetOperation(s.tkop3)
	c:RegisterEffect(e12)
end
function s.pubcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971139)~=0
end
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971130)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971130,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971130)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971130,RESET_PHASE+PHASE_END,0,4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971130.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,4)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,4)
	c99971130[c]=e1
end
function c99971130.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971130)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971130,RESET_PHASE+PHASE_END,0,5-ct)
	if ct>=4 then
	-- 第18回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971130)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971130)
	-- 效果①：特殊召唤暴鬼衍生物
		Duel.RegisterFlagEffect(tp,99971139,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971130,5))
		e:GetLabelObject():Reset()
	end
end



function s.tktg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,99971052,0,
				TYPES_TOKEN_MONSTER,1500,1500,3,RACE_PSYCHO,ATTRIBUTE_WIND) and  Duel.IsExistingMatchingCard(c99971130.filter,tp,0x3f,0x3f,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

function s.tkop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971130.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971130.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
	local token=Duel.CreateToken(tp,99971052)
		-- 衍生物效果：离场增幅
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(s.drawop)
		token:RegisterEffect(e3,true)	
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
-- 衍生物离场增幅
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971130.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971130.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end
















-----------------------

function c99971130.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971130))
end
function c99971130.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function c99971130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971130.filter,tp,0x3f,0x3f,1,nil)  end
end
function c99971130.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971130.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971130.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end