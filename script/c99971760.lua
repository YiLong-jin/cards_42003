--改境的天宫·阿洛艾特
function c99971760.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99971760,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99971760)
	e1:SetCondition(c99971760.spcon)
	e1:SetCost(c99971760.spcost)
	e1:SetTarget(c99971760.sptg)
	e1:SetOperation(c99971760.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99971760,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99971761)
	e2:SetTarget(c99971760.thtg)
	e2:SetOperation(c99971760.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	
end
function c99971760.thfilter2(c,tp)
	return c:IsCode(99971660) and c:IsAbleToHand() and c:IsFaceupEx() and Duel.IsExistingMatchingCard(c99971760.thfilter2a,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
end
function c99971760.thfilter2a(c)
	return c:IsCode(99971670) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971760.thfilter2t(c)
	return c:IsCode(99971660) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971760.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971760.thfilter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp)
	and Duel.GetFlagEffect(tp,99971760)==0 end
	Duel.RegisterFlagEffect(tp,99971760,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99971760.fselect(g)
	return g:FilterCount(c99971760.thfilter2t,nil)==1
end
function c99971760.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(function(c) return c:IsCode(99971670) and c:IsAbleToHand() end,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsCode(99971660) and c:IsAbleToHand() end,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		local g=Group.__add(g1,g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c99971760.fselect,false,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c99971760.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLinkState()
end
function c99971760.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99971760.filter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x67f) 
	and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c99971760.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971760.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99971760.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99971760.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end