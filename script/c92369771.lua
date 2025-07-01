--枪管访问姬•银河洛拉米亚
local m=92369771
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x4b)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--Attribute Dark
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_ADD_ATTRIBUTE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e10)
	--change race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(0xff)
	e1:SetValue(RACE_CYBERSE+RACE_DRAGON+RACE_WARRIOR)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--summon success
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(cm.regop)
	c:RegisterEffect(e9)
	e9:SetLabelObject(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.drcost)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(m,0))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e5:SetProperty(EFFECT_FLAG_DELAY)
		e5:SetCode(EVENT_SUMMON_SUCCESS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1,m)
		e5:SetCondition(cm.atkcon)
		e5:SetOperation(cm.atkop)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e6)
		local e7=e5:Clone()
		e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		c:RegisterEffect(e7)
end
function cm.refil(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(26077387) and Duel.IsExistingMatchingCard(cm.refil0,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.refil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(27548199) and Duel.IsExistingMatchingCard(cm.refil1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.refil1(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(86066372) and Duel.IsExistingMatchingCard(cm.refil2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.refil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(93717133) 
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.refil,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	return #g>0 
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ag=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local x=0
	local g=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local ac=Duel.SelectMatchingCard(tp,cm.refil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,g,tp):GetFirst()
		local bc=Duel.SelectMatchingCard(tp,cm.refil0,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,g,tp):GetFirst()
		local cc=Duel.SelectMatchingCard(tp,cm.refil1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,g,tp):GetFirst()
		local dc=Duel.SelectMatchingCard(tp,cm.refil2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,g,tp):GetFirst()
		g:AddCard(ac)
		g:AddCard(bc)
		g:AddCard(cc)
		g:AddCard(dc)
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	Duel.PayLPCost(tp,100)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x4b,1) end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x4b,1)
	end
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:GetControler()==tp
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.cfilter,1,c,tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.cfilter,c,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=0
	g=e:GetLabelObject():GetLabelObject()
	if #g==0 then 
	Duel.Remove(c,POS_FACEDOWN,REASON_RULE) 
	end 
	local wbc=g:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
		c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)  
		end 
		wbc=g:GetNext()
	end 
end