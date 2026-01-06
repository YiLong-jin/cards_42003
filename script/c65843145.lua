--圣杯 外卖员
function c65843145.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,65843145)
	e0:SetCondition(c65843145.thcon)
	e0:SetTarget(c65843145.thtg)
	e0:SetOperation(c65843145.thop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c65843145.rdcon)
	e1:SetOperation(c65843145.rdop)
	c:RegisterEffect(e1)
end
function c65843145.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x43ef)
end
function c65843145.filter(c)
	return c:IsSetCard(0x43ef) and c:IsAbleToHand()
end
function c65843145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65843145.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c65843145.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65843145.filter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65843145.rdcfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c65843145.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65843145.rdcfilter,1,nil,tp)
end
function c65843145.rdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetValue(Duel.GetTurnCount())
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetValue(0)
	end
	e1:SetCountLimit(1)
	e1:SetCondition(c65843145.retcon)
	e1:SetOperation(c65843145.retop)
	Duel.RegisterEffect(e1,tp)
end
function c65843145.srfilter(c,oc)
	return c:IsSetCard(0x43ef) and c:IsType(0x6) and c:IsAbleToHand()
end
function c65843145.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return Duel.IsExistingMatchingCard(c65843145.srfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
end
function c65843145.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(65843145,2)) then
		Duel.Hint(HINT_CARD,0,65843145)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65843145.srfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end