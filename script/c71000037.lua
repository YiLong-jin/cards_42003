--Sp陷阱 最大油门
local m=71000037
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.cttg)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsSetCard(0x7a0)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_FZONE,0,1,nil) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_FZONE,0,1,nil) then
		Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst():AddCounter(0x104d,1)
	end
end