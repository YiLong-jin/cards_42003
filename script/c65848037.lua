--Sunrise Sunset
function c65848037.initial_effect(c)
	aux.AddCodeList(c,65847994)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(Card.IsRace,RACE_PSYCHO),1)
	c:EnableReviveLimit()
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,65848037,EVENT_TO_HAND,g)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CUSTOM+65848037)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetCurrentPhase()~=PHASE_DRAW and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) end)
	e0:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then local e1=Effect.CreateEffect(e:GetHandler()) e1:SetDescription(aux.Stringid(65848037,1)) e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) e1:SetCode(EVENT_PHASE+PHASE_END) e1:SetReset(RESET_PHASE+PHASE_END) e1:SetLabelObject(c) e1:SetCountLimit(1) e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) return Duel.ReturnToField(e:GetLabelObject(e:GetHandler())) end) Duel.RegisterEffect(e1,tp) end end)
	e0:SetTarget(c65848037.ddtg)
	e0:SetOperation(c65848037.ddop)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c65848037.condition)
	e1:SetTarget(c65848037.target)
	e1:SetOperation(c65848037.operation)
	c:RegisterEffect(e1)
end
function c65848037.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c65848037.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c65848037.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end --and Duel.IsPlayerCanRemove(tp,nil,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c65848037.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65848037.ddfilter,nil,tp)
	if g:GetCount()==0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(65848037,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(65848037,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(c65848037.retcon)
	e1:SetOperation(c65848037.retop)
	Duel.RegisterEffect(e1,tp)
end
function c65848037.retfilter(c)
	return c:GetFlagEffect(65848037)~=0
end
function c65848037.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():IsExists(c65848037.retfilter,1,nil) then
		e:GetLabelObject():DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function c65848037.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c65848037.retfilter,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end
function c65848037.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c65848037.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		tc=sg:GetNext()
	end
end
function c65848037.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c65848037.tdfilter(c)
	return aux.IsCodeListed(c,65847994) and c:IsAbleToDeck() and c:IsFaceup()
end
function c65848037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c65848037.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65848037.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65848037.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c65848037.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65848037,4))
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT) 
		tg:RemoveCard(tc)
		Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
