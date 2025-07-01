--PAQI
function c2107121.initial_effect(c)
--------------------------------------------------------------检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2107121,0))
	--e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,21071211)
	e1:SetCondition(c2107121.condition)
	e1:SetCost(c2107121.tgcost)
	e1:SetTarget(c2107121.tgtg)
	e1:SetOperation(c2107121.tgop)
	c:RegisterEffect(e1)
--------------------------------------------------------------带破
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2107121,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21071212)
	e2:SetValue(c2107121.replaceval)
	e2:SetTarget(c2107121.replacetg)
	e2:SetOperation(c2107121.replaceop)
	c:RegisterEffect(e2)
end
--------------------------------------------------------------检索
function c2107121.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==tp
end
function c2107121.tgfilter(c)
	return c:IsCode(10000080) or c:IsCode(27204311) and c:IsAbleToHand()
end
function c2107121.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoGrave(c,REASON_COST)
end
function c2107121.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2107121.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2107121.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2107121.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SpecialSummonComplete()
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c2107121.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c2107121.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
--------------------------------------------------------------带破
function c2107121.replaceft(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(10)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c2107121.replacetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c2107121.replaceft,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c2107121.replaceval(e,c)
	return c2107121.replaceft(c,e:GetHandlerPlayer())
end
function c2107121.replaceop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
























