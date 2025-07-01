--达摩翠凤蝶
function c10001013.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10001013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10001013)
	e1:SetCondition(c10001013.hspcon)
	e1:SetTarget(c10001013.hsptg)
	e1:SetOperation(c10001013.hspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,10001013+8181841)
	e2:SetCondition(c10001013.thcon)
	e2:SetTarget(c10001013.thtg)
	e2:SetOperation(c10001013.thop)
	c:RegisterEffect(e2)
end
function c10001013.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10001013.hspfilter(c,e,tp)
	return c:IsSetCard(0xcde0) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c10001013.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10001013.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10001013.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10001013.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
function c10001013.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c10001013.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xcde0) and c:IsAbleToHand()
end
function c10001013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10001015) end,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b=Duel.IsExistingMatchingCard(c10001013.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return a or b end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10001013.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10001015) end,tp,LOCATION_ONFIELD,0,1,nil) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b=Duel.IsExistingMatchingCard(c10001013.thfilter,tp,LOCATION_DECK,0,1,nil)
	local op=aux.SelectFromOptions(tp,
		{a,aux.Stringid(10001013,0)},
		{b,aux.Stringid(10001013,1)})	
	if op==1 then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c10001013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end