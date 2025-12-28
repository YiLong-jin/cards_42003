--五行之巅·久远

local s,id,o=GetID()
function s.initial_effect(c)
		--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x67f),3,5)
	c:EnableReviveLimit()
	-- 效果①：特殊召唤时从额外卡组特召式神·贵人
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCountLimit(1,99971100)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	
	
		
	-- 效果：开始增幅
	local e3=Effect.CreateEffect(c)  -- 改为e3
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.descon)
		e3:SetCountLimit(1,99971101)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)  -- 注册e3
	
		-- 1回合1次检索效果
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,2))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
		e12:SetCondition(s.descon1)
	e12:SetCountLimit(1)
	e12:SetTarget(s.thtg)
	e12:SetOperation(s.thop)
	c:RegisterEffect(e12)
end

function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971109)~=0
end
-------------e3
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971100)==0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if Duel.GetFlagEffect(tp,99971100)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971100,RESET_PHASE+PHASE_END,0,5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c99971100.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,5)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,5)
	c99971100[c]=e1
			e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971100,3))
end
function c99971100.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971100)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971100,RESET_PHASE+PHASE_END,0,6-ct)
	if ct>=5 then
	-- 1回合1次检索效果
		Duel.RegisterFlagEffect(tp,99971109,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971100,4))
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971100)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971100)
		e:GetLabelObject():Reset()
	end
end
function s.thfilter(c)
	return c:IsCode(99971130,99971210) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.thfilter,tp,
			LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,
			0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,
		LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,
		LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,
		0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end























-- 效果②：回合前进
function c99971100.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971100))
end
function c99971100.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end


function s.spfilter(c,e,tp)
	return c:IsCode(99971160) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c99971100.filter,tp,0x33f,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c99971100.filter,tp,0x33f,0,1,3,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	while tc do
		local turne=tc[tc]
		local op=turne:GetOperation()
		local code=tc:GetCode()
		local flag=5
		while flag>0 do
			if Duel.IsExistingMatchingCard(c99971100.filter1,tp,0x33f,0,1,nil,code) then 
				op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
				flag=flag-1
			else
				flag=0
			end
		end
		tc=g:GetNext()
	end
end



