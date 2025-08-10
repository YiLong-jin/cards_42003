--芝士 蛋糕
function c40800021.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(40800021,0))
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,40800021)
	e0:SetCost(c40800021.cost)
	e0:SetTarget(c40800021.tgtg)
	e0:SetOperation(c40800021.tgop)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c40800021.cost)
	e1:SetTarget(c40800021.sptg)
	e1:SetOperation(c40800021.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(40800021,ACTIVITY_SUMMON,c40800021.counterfilter)
	Duel.AddCustomActivityCounter(40800021,ACTIVITY_SPSUMMON,c40800021.counterfilter)
end
c40800021.SetCard_RR_ZS=true 
function c40800021.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER)
end
function c40800021.splimit(e,c)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER))
end
function c40800021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(40800021,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(40800021,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40800021.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c40800021.cfilter(c)
	return c.SetCard_RR_ZS and c:IsAbleToGrave()
end
function c40800021.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40800021.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c40800021.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c40800021.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local c=e:GetHandler()
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40800021.filter(c,e,tp)
	return c.SetCard_RR_ZS and c:IsAttackBelow(2100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_DECK))
end
function c40800021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40800021.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,40800021)==0 end
	Duel.RegisterFlagEffect(tp,40800021,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c40800021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40800021.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end