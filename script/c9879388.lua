--完美的可爱
function c9879388.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879388,1))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9879388+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9879388.condition1)
	e1:SetTarget(c9879388.target1)
	e1:SetOperation(c9879388.activate1)
	c:RegisterEffect(e1)
end
function c9879388.filter11(c)
	return c:IsFaceup() and c:IsCanHaveCounter(0x7e2)
end
function c9879388.filter1(c,e,tp)
	return c:IsCanHaveCounter(0x7e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879388.condition1(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.IsExistingMatchingCard(c9879388.filter11,tp,LOCATION_MZONE,0,1,nil)
end
function c9879388.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879388.filter11,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x7e2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9879388.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c9879388.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(c9879388.filter11,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x7e2,3)
		tc=g:GetNext()
	end
	 if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9879388,0))  then 
		local sg=g1:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end