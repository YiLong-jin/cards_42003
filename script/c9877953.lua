--一如平常
function c9877953.initial_effect(c)
	aux.AddCodeList(c,9877873,9877877,9877951)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9877953+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9877953.tg)
	e1:SetOperation(c9877953.op)
	c:RegisterEffect(e1)
end
function c9877953.spfilter(c,e,tp)
	return (aux.IsCodeListed(c,9877877) or aux.IsCodeListed(c,9877951)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877953.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877953.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end
function c9877953.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877953.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9877953.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9877953.splimit(e,c)
	return not (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877877) or aux.IsCodeListed(c,9877951))
end