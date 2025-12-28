--次元超越
local s,id,o=GetID()
function s.initial_effect(c)


	-- 效果①：持续公开并等待18回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99971030)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
	
	-- 效果②：魔法·陷阱发动时前进回合
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.advcon)
	e2:SetOperation(s.advop)
	--c:RegisterEffect(e2)
	--Activate




		local e22=Effect.CreateEffect(c)
		e22:SetDescription(aux.Stringid(id,1))
   	 	e22:SetType(EFFECT_TYPE_IGNITION)
   	 	e22:SetRange(LOCATION_HAND)
   	 	e22:SetReset(RESET_EVENT)
   	 	e22:SetCondition(s.coincon)
		e22:SetCost(s.turncost)
		e22:SetTarget(s.turntg)
		e22:SetOperation(s.turnop)
		c:RegisterEffect(e22)
end

-- 效果②：回合前进
function s.advcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tpe=re:GetActiveType()
	return c:IsPublic() and (tpe==TYPE_SPELL or tpe==TYPE_QUICKPLAY+TYPE_SPELL) and rp==tp and re:GetHandler():IsSetCard(0x67f)
end
function c99971030.filter(c)
	return c:GetFlagEffect(1082946)~=0 and c:IsSetCard(0x67f)
end
function s.advop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99971030,6))
	local g=Duel.SelectMatchingCard(tp,c99971030.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
	Duel.Hint(HINT_CARD,1-tp,id)
end



-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971030)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971030,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971030)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971030,RESET_PHASE+PHASE_END,0,18)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971030.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,18)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,18)
	c99971030[c]=e1
end

function s.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971035)==0 and Duel.GetFlagEffect(tp,99971039)~=0
end
function c99971030.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971030)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971030,RESET_PHASE+PHASE_END,0,19-ct)
	if ct>=18 then
	-- 第18回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971030)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971030)
		Duel.RegisterFlagEffect(tp,99971039,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971030,5))
		e:GetLabelObject():Reset()
	end
end


function s.turncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end

function s.turntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		return #g>0 and Duel.IsPlayerCanDraw(tp,5) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) 
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end

function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
					Duel.RegisterFlagEffect(tp,99971035,nil,0,98)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,5,REASON_EFFECT)
		--增幅*3
		-- 效果②：魔法·陷阱发动时前进回合
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCondition(s.advcon3)
		e2:SetOperation(s.advop3)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.advop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99971030,6))
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=3
	while flag>0 do
		if Duel.IsExistingMatchingCard(s.filter33,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
end

function s.filter3(c)
	return c:GetFlagEffect(1082946)~=0 and c:IsSetCard(0x67f)
end

function s.filter33(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end

function s.advcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tpe=re:GetActiveType()
	return (tpe==TYPE_SPELL or tpe==TYPE_QUICKPLAY+TYPE_SPELL) and rp==tp and re:GetHandler():IsSetCard(0x67f)
end






















function c99971030.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971030,4))
end