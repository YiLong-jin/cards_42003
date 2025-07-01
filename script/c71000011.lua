--Sp魔法 闪电权杖
local m=71000011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.ctcost(2))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.ctcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x104d)>=ct end
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),tp,LOCATION_MZONE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),tp,LOCATION_MZONE,0,1,c) then
		local sg=Duel.SelectMatchingCard(tp,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),tp,LOCATION_MZONE,0,1,1,nil)
		if sg then
			local tc=sg:GetFirst()
			local isBattle=tc:IsRelateToBattle()
			if Duel.Destroy(tc,REASON_EFFECT) and isBattle and tc:GetAttack()>0 then
				Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
			end
		end
	end
end