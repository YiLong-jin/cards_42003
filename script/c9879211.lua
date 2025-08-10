--核心列车 幻影疾驰
c9879211.hxlc=true
function c9879211.initial_effect(c)
	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND)
	e02:SetCountLimit(1,9879211)
	e02:SetCondition(c9879211.spcon)
	e02:SetTarget(c9879211.sptg)
	e02:SetOperation(c9879211.spop)
	c:RegisterEffect(e02)  

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879211,0))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,1879211)
	e12:SetTarget(c9879211.thtg)
	e12:SetOperation(c9879211.thop)
	c:RegisterEffect(e12)
	
end
function c9879211.f(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end
function c9879211.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9879211.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9879211.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879211.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879211.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c9879211.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) and (c:IsRankAbove(10) or c:IsLevel(10)))
end


function c9879211.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(10) and c:IsAbleToHand()
end
function c9879211.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879211.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879211.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879211.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879211.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
