--Sp陷阱 降速陷阱
local m=71000038
local cm=_G["c"..m]
function c71000038.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--counter down
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.ctcon)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.filter(c)
	return c:IsFaceup() and c:GetCounter(0x104d)>0
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,1-tp,LOCATION_FZONE,0,1,nil) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(cm.filter,1-tp,LOCATION_FZONE,0,nil):GetFirst()
	if tc then
		local d=math.floor(ev/1000)
		tc:RemoveCounter(tp,0x104d,d,REASON_EFFECT)
	end
end
