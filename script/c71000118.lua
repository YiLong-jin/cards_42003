--惶惶压抑的恣意放纵
local m=71000118
local cm=_G["c"..m]
function cm.initial_effect(c)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_HANDES+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and e:GetHandler():IsFacedown()
end
function cm.disfilter(c)
	return (not c:IsDisabled() or c:IsType(TYPE_TRAPMONSTER)) and not (c:IsType(TYPE_NORMAL) and bit.band(c:GetOriginalType(),TYPE_NORMAL))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()):Filter(cm.disfilter,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,0,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Filter(cm.disfilter,nil)
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		g1:RemoveCard(c)
	end
	for nc in aux.Next(g1) do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			nc:RegisterEffect(e3)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.turncon)
	e2:SetOperation(cm.turnop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,10)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,10)
	cm[c]=e2
end
function cm.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==10 then
		e:GetLabelObject():Reset()
		e:GetOwner():ResetFlagEffect(m)
	end
	if Duel.DiscardHand(tp,nil,1,1,REASON_RULE,nil)==0 then
		local LP=Duel.GetLP(tp)
		if LP<1000 then LP=1000 end
		Duel.SetLP(tp,LP-1000)
		Duel.Recover(1-tp,1000,REASON_EFFECT+REASON_DISCARD)
	end
end











