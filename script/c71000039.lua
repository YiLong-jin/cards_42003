--Sp陷阱 加速地带
local m=71000039
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(cm.ctcon)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsSetCard(0x7a0) and ep~=tp
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_FZONE,0,1,nil) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_FZONE,0,1,nil) then
		Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst():AddCounter(0x104d,6,true)
	end
end
