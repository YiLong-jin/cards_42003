--未知的考究

local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,99971060)
	e2:SetTarget(c99971060.target)
	e2:SetOperation(c99971060.activate)
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
	
end
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971060)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971060,2))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971060)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971060,RESET_PHASE+PHASE_END,0,50)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971060.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,50)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,50)
	c99971060[c]=e1
end
function c99971060.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971060)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971060,RESET_PHASE+PHASE_END,0,51-ct)
	if ct>=5 then
	-- 第5回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.RegisterFlagEffect(tp,99971061,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971060,3))
	end
	if ct>=10 then
	-- 第10回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.RegisterFlagEffect(tp,99971062,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971060,4))
	end
		if ct>=20 then
	-- 第20回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.RegisterFlagEffect(tp,99971063,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971060,5))
	end
			if ct>=50 then
	-- 第50回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.RegisterFlagEffect(tp,99971064,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971060,6))
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971060)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971060)
		e:GetLabelObject():Reset()
	end
end













-----------发动效果--------------------------
function c99971060.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971060))
end
function c99971060.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function c99971060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971060.filter,tp,0x3f,0x3f,1,nil) end

end
function c99971060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971060.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=5
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971060.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
	local ct1=Duel.GetFlagEffect(tp,99971061)
	local ct2=Duel.GetFlagEffect(tp,99971062)
	local ct3=Duel.GetFlagEffect(tp,99971063)
	local ct4=Duel.GetFlagEffect(tp,99971064)
	if ct1>0 then
		local g1=Duel.GetDecktopGroup(tp,2)
			if #g1>=2 then
				Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
   		 	end
   	end
	if ct2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		if #g2>0 then
		Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
		end
   	end
	if ct3>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
   	 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g3=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g3>0 then
			Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		end
   	end
	if ct4>0 then
			Duel.Hint(HINT_CARD,1-tp,id)
					Duel.Hint(HINT_CARD,1-tp,id)
							Duel.Hint(HINT_CARD,1-tp,id)
									Duel.Hint(HINT_CARD,1-tp,id)
											Duel.Hint(HINT_CARD,1-tp,id)
		Duel.Win(tp,0x167f)
		
   	end
end
function s.filter4(c,e,tp)
	return c:IsSetCard(0x67f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-----------除外检测-----------
function s.filter2(c)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
