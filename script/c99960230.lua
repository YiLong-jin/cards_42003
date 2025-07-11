--梦符「二重结界」
function c99960230.initial_effect(c)
	
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99960230+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c99960230.activate1)
	c:RegisterEffect(e1)
	
	
	
	
end
c99960230.Savior_bolishenshe=true



function c99960230.activate1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c99960230.condition)
	e1:SetOperation(c99960230.handes)
	Duel.RegisterEffect(e1,tp)
end
function c99960230.cfilter(c)
	return c:IsFaceup() and c:IsCode(99960190)
end
function c99960230.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
c99960230[0]=0
function c99960230.handes(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_EXTRA or id==c99960230[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c99960230[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(99960230,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.BreakEffect()
	else Duel.NegateEffect(ev) end
end