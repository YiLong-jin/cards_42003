--真理灾杰·莱奥

local s,id,o=GetID()
function s.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c99971110.ffilter,3,true)
	
	
	
		-- 效果①：召唤/特殊召唤时前进回合（从e3开始）
	local e3=Effect.CreateEffect(c)  -- 改为e3
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,99971110)
	local e4=e3:Clone()  -- 改为e4
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetCountLimit(1,99971110)
	e3:SetTarget(s.advtg)
	e3:SetOperation(s.advop)
		e4:SetTarget(s.advtg)
	e4:SetOperation(s.advop)
	c:RegisterEffect(e3)  -- 注册e3
	c:RegisterEffect(e4)  -- 注册e4
	
	
	-- 被战斗破坏时破坏对方全场怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
end


-- 条件：被战斗破坏
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end












-------------------------
function s.advtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971110.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)  end
end
-- 效果②：回合前进
function c99971110.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971110))
end
function c99971110.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function s.advop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971110.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,3,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	while tc do
		local turne=tc[tc]
		local op=turne:GetOperation()
		local code=tc:GetCode()
		local flag=9
		while flag>0 do
			if Duel.IsExistingMatchingCard(c99971110.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,code) then 
				op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
				flag=flag-1
			else
				flag=0
			end
		end
		tc=g:GetNext()
	end
end
















function c99971110.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x67f)
end