--Sp魔法 累加上升
local m=71000006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_HANDES)
	e1:SetCost(cm.ctcost(2))
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
end
function cm.ctcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x104d)>=ct end
	end
end
function cm.filter(c)
	return c:IsSetCard(0x7a0)
end
function cm.difilter(c)
	return c:IsDiscardable()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.difilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_FZONE,0,1,nil) then
		local num=Duel.DiscardHand(tp,cm.difilter,1,4,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst():AddCounter(0x104d,num,true)
	end
end

