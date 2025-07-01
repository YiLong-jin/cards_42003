--真理具象化
function c17030920.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,40)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c17030920.acop)
	c:RegisterEffect(e2)
	--pendulum set/spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17030920,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetLabel(8)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c17030920.cost)
	e3:SetTarget(c17030920.rptg)
	e3:SetOperation(c17030920.rpop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17030920,3))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetLabel(25)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c17030920.cost)
	e4:SetTarget(c17030920.rmtg)
	e4:SetOperation(c17030920.rmop)
	c:RegisterEffect(e4)
	--made in heaven
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17030920,4))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetLabel(40)
	e5:SetCost(c17030920.cost)
	e5:SetTarget(c17030920.skiptg)
	e5:SetOperation(c17030920.skipop)
	c:RegisterEffect(e5)
end
function c17030920.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsControler(tp) and c:IsType(TYPE_RITUAL)
end
function c17030920.acop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c17030920.cfilter,nil,tp)
	local ct2=e:GetHandler():GetCounter(0x1)
	local cou=math.min(ct*5,40-ct2)
	if ct>0 then
		e:GetHandler():AddCounter(0x1,cou,true)
	end
end
function c17030920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,ct,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,ct,REASON_COST)
end
function c17030920.rpfilter(c,e,tp)
	return c:IsSetCard(0x7f6) and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c17030920.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return (b1 or b2 or b3>0) and Duel.IsExistingMatchingCard(c17030920.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c17030920.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17030920,5))
	local g=Duel.SelectMatchingCard(tp,c17030920.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local b2=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local off=1
	local ops={}
	local opval={}
	if b1 or b2 then
		ops[off]=aux.Stringid(17030920,0)
		opval[off-1]=1
		off=off+1
	end
	if b3>0 then
		ops[off]=aux.Stringid(17030920,1)
		opval[off-1]=2
		off=off+1
	end
	if op==0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17030920.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c17030920.chlimit)
end
function c17030920.chlimit(e,ep,tp)
	return tp==ep
end
function c17030920.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c17030920.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function c17030920.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetCondition(c17030920.skipcon)
	Duel.RegisterEffect(e1,tp)
end
function c17030920.skipcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end