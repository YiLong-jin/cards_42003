--进化龙·活堡龙
function c10701193.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701193,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10701193)
	e1:SetTarget(c10701193.sptg)
	e1:SetOperation(c10701193.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_REPTILE+RACE_DINOSAUR+RACE_DRAGON))
	e3:SetValue(500)
	e3:SetCondition(c10701193.condition)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c10701193.filter1(c,e,tp)
	return c:IsRace(RACE_REPTILE+RACE_DINOSAUR) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701193.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end 
		local loc=LOCATION_HAND 
		local st=e:GetHandler():GetSummonType()
		if (st&SUMMON_VALUE_EVOLTILE>0 or (re and re:GetHandler():IsSetCard(0x10e) and re:GetHandler():IsType(TYPE_SPELL))) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c10701193.filter1,tp,loc,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10701193.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND 
	local st=e:GetHandler():GetSummonType()
	if (st&SUMMON_VALUE_EVOLTILE>0 or (re and re:GetHandler():IsSetCard(0x10e) and re:GetHandler():IsType(TYPE_SPELL))) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701193.filter1,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701193.condition(e)
	return e:GetHandler():GetOriginalRace()==RACE_DRAGON 
end