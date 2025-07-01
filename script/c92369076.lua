--星云迸发
local m=92369076
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(3,m)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.tog(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToGrave()
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local te,race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_RACE)
	local tsp=te:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.tog,1-tsp,LOCATION_DECK,0,nil)
	return bit.band(race,RACE_ROCK)~=0
		and #g>0 and Duel.IsChainDisablable(ev) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	local tsp=te:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.tog,1-tsp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(1-tsp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		local tg=g:Select(1-tsp,1,1,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
			Duel.NegateEffect(ev)
		end
	end
end
--Effect 2
function cm.mf(c)
	return not c:IsRace(RACE_ROCK) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.mf(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.mf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.mf,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(RACE_ROCK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end  