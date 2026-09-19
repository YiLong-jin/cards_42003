--环指野兽派讲解员 罗佳
local s,id,o=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(s.reptg)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)
 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.effcon)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fe0) and c:IsLevelBelow(3)
		and c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
			and not c:IsReason(REASON_REPLACE)
			and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(1-tp,s.repfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=0
	if c:GetReasonPlayer()==1-tp then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	end
	if op==0 then
		s.setatkprot(c,tp)
	else
		s.setchainprot(c,tp)
	end
end
function s.setatkprot(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.atkfil)
	local ph=RESET_OPPO_TURN
	if Duel.GetTurnPlayer()~=tp then ph=RESET_SELF_TURN end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+ph,1)
	Duel.RegisterEffect(e1,tp)
end
function s.atkfil(e,c)
	return c:IsFaceup() and c:IsSetCard(0x7fe0)
end
function s.setchainprot(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.acfil)
	local ph=RESET_OPPO_TURN
	if Duel.GetTurnPlayer()~=tp then ph=RESET_SELF_TURN end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW+ph,1)
	Duel.RegisterEffect(e1,tp)
end
function s.acfil(e,re,tp)
	local ct=Duel.GetCurrentChain()
	if ct==0 then return false end
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local pl=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_PLAYER)
	return te and pl==e:GetHandlerPlayer() and te:GetHandler():IsSetCard(0x7fe0)
end