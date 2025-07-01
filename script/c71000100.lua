--永不抛弃的信念
local m=71000100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--e
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0)) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTarget(cm.target)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(cm.matval)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(cm.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>=500 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local lp0=Duel.GetLP(tp)
	if lp0>=500 then
		Duel.SetLP(tp,lp0-500)
	end
end
function cm.eftg(e,c)
	return true
end
function cm.matval(e,lc,mg,c,tp)
	return lc:IsCode(71000101),true
end



