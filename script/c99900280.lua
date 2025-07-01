--圆环的使者 美树沙耶香
function c99900280.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x676),3,true)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99900280,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99900280)
	e1:SetCost(c99900280.cost)
	e1:SetCondition(c99900280.fmcon)
	e1:SetOperation(c99900280.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99900280,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c99900280.indcon)
	e2:SetOperation(c99900280.indop)
	c:RegisterEffect(e2) 
end
function c99900280.fmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99900280.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
	local g=Duel.GetOperatedGroup()
	local tt=0
	local tc=g:GetFirst()
	while tc do
		  if tc:IsType(TYPE_MONSTER) then
		  local atk=tc:GetAttack()
		  tt=tt+atk end
		  tc=g:GetNext()
	end  
	   e:SetLabel(tt)
end
function c99900280.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tt=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(tt)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tt)
end
function c99900280.operation(e,tp,eg,ep,ev,re,r,rp)
	local tt=e:GetLabel()
	Duel.Recover(tp,tt,REASON_EFFECT)
end

function c99900280.indcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 
		and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99900280.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99900280,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1)
	e3:SetCondition(c99900280.discon)
	e3:SetTarget(c99900280.distg)
	e3:SetOperation(c99900280.disop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900280,1))
end
function c99900280.dfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c99900280.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c99900280.dfilter,1,nil,1-tp)
end
function c99900280.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c99900280.dfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c99900280.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c99900280.dfilter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
