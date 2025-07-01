--高速魔咒－一对一
function c10701112.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10701112.cost)
	e1:SetTarget(c10701112.target)
	e1:SetOperation(c10701112.activate)
	c:RegisterEffect(e1)
end
function c10701112.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c10701112.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c10701112.filter(c,e,tp)
	return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10701112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c10701112.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,4,REASON_COST)
		else
			return Duel.IsExistingMatchingCard(c10701112.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,4,REASON_COST)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c10701112.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,4,REASON_COST)
		Duel.SendtoGrave(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10701112.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701112.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end