--天外的一隅

local s,id,o=GetID()
function s.initial_effect(c)
	-- e2：主要效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	
		
		
	-- 效果①：持续公开并等待5回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
	
	
		local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
		e22:SetDescription(aux.Stringid(id,3))
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_GRAVE)
		e22:SetCondition(s.pubcon1)
	e22:SetCost(s.cost3)
	e22:SetTarget(s.target3)
	e22:SetOperation(s.activate3)
	c:RegisterEffect(e22)
	
end

function s.pubcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971209)~=0
end
-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971200)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971200,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971200)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971200,RESET_PHASE+PHASE_END,0,5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971200.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,5)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,5)
	c99971200[c]=e1
end
function c99971200.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971200)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971200,RESET_PHASE+PHASE_END,0,6-ct)
	if ct>=5 then
	-- 第9回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971200)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971200)
	
		Duel.RegisterFlagEffect(tp,99971209,nil,0,98)
	
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971200,5))
		e:GetLabelObject():Reset()
	end
end




function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.filter13(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end

function s.filter23(c,e,tp)
	return c:IsSetCard(0x67f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter13,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.filter23,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
end

function s.activate3(e,tp,eg,ep,ev,re,r,rp)
	-- 必须有两个条件才能继续
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	-- 返回除外卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter13,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g==0 then return end
	
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		-- 特殊召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.filter23,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end




















function c99971200.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971200))
end
function c99971200.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end

function s.filter4(c)
	return c:IsSetCard(0x67f) and c:IsSummonable(true,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_HAND,0,1,nil) and  Duel.IsExistingMatchingCard(c99971200.filter,tp,0x3f,0x3f,1,nil)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_HAND,0,1,1,nil)
	
	if #g1>0 then
		local tc1=g1:GetFirst()
		if tc1 then
			Duel.Summon(tp,tc1,true,nil)
		end
	end
	
	
	
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971200.filter,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	local code=tc:GetCode()
	local flag=2
	while flag>0 do
		if Duel.IsExistingMatchingCard(c99971200.filter1,tp,0x3f,0x3f,1,nil,code) then 
			op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
			flag=flag-1
		else
			flag=0
		end
	end
	
end