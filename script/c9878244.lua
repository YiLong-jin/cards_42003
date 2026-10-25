--今晚共享盛宴
function c9878244.initial_effect(c)
	aux.AddCodeList(c,9877896,9877905,9878245,9878244)
	c:SetUniqueOnField(1,0,9878244)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9878244+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9878244.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,9877905))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,9877905))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0) 
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,9877905))
	e5:SetValue(1)
	c:RegisterEffect(e5)

	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EFFECT_UPDATE_DEFENSE)
	e12:SetTarget(aux.TargetBoolFunction(Card.IsCode,9878245))
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetValue(1000)
	c:RegisterEffect(e12)

	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,9878245))
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c9878244.immval)
	c:RegisterEffect(e3)
	
end
function c9878244.immval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE 
end
function c9878244.thfilter(c,e,tp) 
	return  (c:IsCode(9877905) or c:IsCode(9878245) ) and c:IsType(TYPE_MONSTER)
end 
function c9878244.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9878244.thfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9878244,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sg:CompleteProcedure()
	end
end