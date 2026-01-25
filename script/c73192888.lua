--Guiding Star
---@param c Card
function c73192888.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,73192888+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c73192888.cost)
	e1:SetTarget(c73192888.target)
	e1:SetOperation(c73192888.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(73192888,ACTIVITY_SPSUMMON,c73192888.counterfilter)
end
function c73192888.counterfilter(c)
	return not c:IsSummonableCard()
end
function c73192888.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(73192888,tp,ACTIVITY_SPSUMMON)==0
			and Duel.IsExistingMatchingCard(c73192888.filter1,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(c73192888.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c73192888.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c73192888.splimit(e,c)
	return not c:IsSummonableCard()
end
function c73192888.filter1(c)
	return not c:IsSummonableCard()
end
function c73192888.filter2(c,att)
	return c:GetAttribute()~=att and not c:IsSummonableCard()
end
function c73192888.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c73192888.filter1,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(c73192888.filter1,tp,LOCATION_DECK,0,1,nil)
	end
end
function c73192888.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c73192888.filter1,tp,LOCATION_HAND,0,1,1,nil)
	if #g1>0 then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c73192888.filter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetAttribute())
		if #g2>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
