--即兴合奏
function c9879062.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879062,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9879062+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9879062.condition1)
	e1:SetTarget(c9879062.target1)
	e1:SetOperation(c9879062.activate1)
	c:RegisterEffect(e1)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9879062,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,1877278)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c9879062.sptg2)
	e5:SetOperation(c9879062.spop2)
	c:RegisterEffect(e5)
end
function c9879062.filter11(c)
	return c:IsFaceup() and c:IsCanHaveCounter(0x7e2)
end
function c9879062.condition1(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.IsExistingMatchingCard(c9879062.filter11,tp,LOCATION_MZONE,0,1,nil)
end
function c9879062.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879062.filter11,tp,LOCATION_MZONE,0,1,nil) end
end
function c9879062.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9879062.filter11,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x7e2,2)
		tc=g:GetNext()
	end
end


function c9879062.spfilter(c,e,tp)
	return c:IsCanHaveCounter(0x7e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c9879062.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c9879062.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c9879062.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879062.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end