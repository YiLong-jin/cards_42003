--马纳利亚的密友·古蕾娅&安

local s,id,o=GetID()
function s.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c99971120.ffilter,2,true)
	
	
	
		-- 效果①：召唤/特殊召唤时前进回合（从e3开始）
	local e3=Effect.CreateEffect(c)  -- 改为e3
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,99971120)
	local e4=e3:Clone()  -- 改为e4
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.advtg)
	e3:SetOperation(s.advop)
	e4:SetTarget(s.advtg)
	e4:SetOperation(s.advop)
	c:RegisterEffect(e3)  -- 注册e3
	c:RegisterEffect(e4)  -- 注册e4
	
	
	
	-- 双方回合破坏对方怪兽效果（从e2开始）
	local e2=Effect.CreateEffect(c)  -- 改为e2
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,99971121)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)  -- 注册e2
	
end






function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end











-------------------------
function c99971120.advtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971120.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)  end
end
-- 效果②：回合前进
function c99971120.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971120))
end
function c99971120.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function s.advop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971120.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,5,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	while tc do
		local turne=tc[tc]
		local op=turne:GetOperation()
		local code=tc:GetCode()
		local flag=5
		while flag>0 do
			if Duel.IsExistingMatchingCard(c99971120.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,code) then 
				op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
				flag=flag-1
			else
				flag=0
			end
		end
		tc=g:GetNext()
	end
end
















function c99971120.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x67f)
end