--圣杯重赛
function c65843146.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65843146+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65843146.sscon)
	e1:SetTarget(c65843146.target)
	e1:SetOperation(c65843146.activate)
	c:RegisterEffect(e1)
end
function c65843146.ssfilter(c)
	return c:IsSetCard(0x43ef) and c:IsFaceup()
end
function c65843146.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65843146.ssfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c65843146.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65843146.thfilter0(c)
	return c:IsSetCard(0x43ef) and c:IsAbleToHand() and c:IsType(0x6)
end
function c65843146.thfilter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsSetCard(0x43ef)
end
function c65843146.thfilter2(c)
	return c:IsCode(65843146) and c:IsAbleToHand()
end
function c65843146.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local hg0=Duel.GetMatchingGroup(aux.NecroValleyFilter(c65843146.thfilter0),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if ct>=1 and hg0:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65843146,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg0=hg0:Select(tp,1,1,nil)
		Duel.SendtoHand(shg0,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg0)
	end
	if ct>=2 and Duel.IsExistingMatchingCard(c65843146.thfilter1,tp,LOCATION_DECK,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(65843146,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=Duel.SelectMatchingCard(tp,c65843146.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if #shg1>0 then
			Duel.SendtoHand(shg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,shg1)
		end
	end
	if ct>=3  then
		Duel.BreakEffect()
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
	if ct==4  then
		Duel.BreakEffect()
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(65843146,3))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCountLimit(1,6584324)
		e2:SetValue(c65843146.pendvalue)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65843146.pendvalue(e,c)
	return c:IsType(TYPE_NORMAL)
end
