--反噬的旧制
local m=71000105
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,m-1,m-2,m-3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.chcon1)
	e1:SetOperation(cm.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.chcon2)
	e2:SetOperation(cm.chop2)
	c:RegisterEffect(e2)
end
function cm.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(65396880) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.chop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(m)>0
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rep_op)
end
function cm.rep_op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end