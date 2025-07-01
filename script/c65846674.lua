--CAN－Sp：D
local m=65846674
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,65846670)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,65846670),aux.NonTuner(Card.IsRace,RACE_PSYCHO),1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,m,EVENT_TO_HAND,g)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return Duel.GetCurrentPhase()~=PHASE_DRAW and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) end)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then local e1=Effect.CreateEffect(e:GetHandler()) e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) e1:SetCode(EVENT_PHASE+PHASE_END) e1:SetReset(RESET_PHASE+PHASE_END) e1:SetLabelObject(c) e1:SetCountLimit(1) e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) return Duel.ReturnToField(e:GetLabelObject(e:GetHandler())) end) Duel.RegisterEffect(e1,tp) end end)
	e3:SetTarget(cm.ddtg)
	e3:SetOperation(cm.ddop)
	c:RegisterEffect(e3)
	
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_PSYCHO) and c:IsFaceup() and c:IsAbleToHand() end,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,function(c) return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_PSYCHO) and c:IsFaceup() and c:IsAbleToHand() end,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsCode(65846670) and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil,tp,POS_FACEDOWN)
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)   
	end
end
function cm.spconfl(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(function(c) return c:IsType(TYPE_TUNER) and c:IsRace(RACE_PSYCHO) end,1,nil) and g:IsExists(function(c) return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PSYCHO) and not c:IsType(TYPE_TUNER) end,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.spconfl,2,2,tp,c) and Duel.GetFlagEffect(tp,m)==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,cm.spconfl,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function cm.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end --and Duel.IsPlayerCanRemove(tp,nil,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ddfilter,nil,tp)
	if g:GetCount()==0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.retcon)
	e1:SetOperation(cm.retop)
	Duel.RegisterEffect(e1,tp)
end
function cm.retfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():IsExists(cm.retfilter,1,nil) then
		e:GetLabelObject():DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(s.retfilter,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		tc=sg:GetNext()
	end
end