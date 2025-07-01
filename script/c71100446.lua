--白骸的记忆碎片
local s,id,o=GetID()
function s.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(38572779,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id-1)
	e1:SetCondition(s.immcon)
	e1:SetCost(s.immcost)
	e1:SetOperation(s.immop)
	c:RegisterEffect(e1)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end
s.Automatic_chess_piece=true --「自动棋子」记述
s.Dead_souls_pawn=true --「死魂棋子」记述
function s.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.immf(c)
	return (c.Automatic_chess_piece or c.Dead_souls_pawn) and c:IsFaceup()
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local tg = Duel.GetMatchingGroup(s.immf,tp,LOCATION_ONFIELD,0,nil)
	for tc in aux.Next(tg) do
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_ONFIELD)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(s.efilter1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc:RegisterEffect(e4)
	end
end
function s.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_REMOVED) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.negcon)
	e1:SetOperation(s.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.setfilter(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA) and c:GetMaterial():IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.setfilter,1,nil,nil,tp)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	local g=eg:Filter(s.setfilter,nil,e,tp)
	local tc=g:GetFirst()
	if tc then 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	e:Reset()
end
