--星之再起
function c65842054.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65842054.cost)
	e1:SetTarget(c65842054.target)
	e1:SetOperation(c65842054.activate)
	c:RegisterEffect(e1)
end
function c65842054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,e:GetHandler())  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c65842054.filter(c,e,tp)
	return c:IsLevelBelow(7) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c65842054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65842054.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65842054.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65842054.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()==0 then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsCode(24094653) and c:IsAbleToHand() end),tp,LOCATION_GRAVE,0,nil)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65842054,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lg=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(lg,nil,REASON_EFFECT)
	end
end
