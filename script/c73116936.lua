--指令：静谧封锁
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.INVASION)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
----------------------------------------------------------------------------------------------------------------------------------------	
--[[	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)]]
end
----------------------------------------------------------------------------------------------------------------------------------------
	function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.con(c)
	return c:IsFaceup() and c:IsSetCard(0x7ac)
end
	function s.INVASION(e,tp,eg,ep,ev,re,r,rp)
	return	Duel.IsExistingMatchingCard(s.con,tp,LOCATION_MZONE,0,1,nil)
end
	function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
	function s.op(e,tp,eg,ep,ev,re,r,rp)
	local f=Duel.SelectOption(1-tp,1056,1063,1073,1074,1076)
	local b
	if f==0 then b=TYPE_FUSION end
	if f==1 then b=TYPE_SYNCHRO end
	if f==2 then b=TYPE_XYZ end
	if f==3 then b=TYPE_PENDULUM end
	if f==4 then b=TYPE_LINK end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(b)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.fbiwarning)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
		e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e2,tp)
end
	function s.fbiwarning(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&e:GetLabel()==0 and c:IsLocation(LOCATION_EXTRA)
end
	function s.fbiopendoor(e)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetCurrentPhase()==PHASE_DRAW
end
function s.tgfilter(c)
	return c:IsSetCard(0x8ac) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end