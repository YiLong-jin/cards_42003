--星空的小小愿望
function c9877921.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9877921+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9877921.condition)
	e1:SetTarget(c9877921.tg)
	e1:SetOperation(c9877921.op)
	c:RegisterEffect(e1)
end
function c9877921.filter1(c)
	return aux.IsCodeListed(c,9877918) and c:IsFaceup()
end
function c9877921.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9877921.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c9877921.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9877873) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877921.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877921.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end
function c9877921.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877921.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9877921.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end

function c9877921.splimit(e,c)
	return not (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877883)) 
end