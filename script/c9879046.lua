--超
function c9879046.initial_effect(c)
	aux.AddCodeList(c,9879042)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	local e11=Effect.CreateEffect(c) 
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e11:SetCode(EVENT_SUMMON_SUCCESS) 
	e11:SetProperty(EFFECT_FLAG_DELAY) 
	e11:SetCountLimit(1,9879046) 
	e11:SetTarget(c9879046.sptg1) 
	e11:SetOperation(c9879046.spop1) 
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e12)
	
end
function c9879046.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(c,9879042) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(6)
end 
function c9879046.sptg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9879046.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c9879046.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879046.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end