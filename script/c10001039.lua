--环指艺术交流集会
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsSetCard(0x7fe0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.spfilter(c, e, tp)
	return c:IsSetCard(0x7fe0) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.gycount()
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetCode)
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
			or (s.gycount() >= 4 and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, e, tp))
	end
	local other = Duel.GetFieldGroup(tp, 0, LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,other,1,0,0)
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local choice = aux.SelectFromOptions(tp, {true, aux.Stringid(id, 1)}, {s.gycount() >= 4, aux.Stringid(id, 2)})
	if choice == 1 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g == 0 then return end
		Duel.ConfirmCards(1 - tp, g)
		if Duel.SendtoHand(g, nil, REASON_EFFECT) == 0 then return end
	elseif choice == 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
		if #g == 0 then return end
		if Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) == 0 then return end
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local des = Duel.SelectMatchingCard(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.HintSelection(des)
	Duel.Destroy(des, REASON_EFFECT)
end