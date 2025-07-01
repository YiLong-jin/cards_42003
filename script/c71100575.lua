--死灵舞者 僵尸参谋
function c71100575.initial_effect(c) 
	c:EnableCounterPermit(0x17d7)
	--ct 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c71100575.ctcon)
	e1:SetOperation(c71100575.ctop)
	c:RegisterEffect(e1)	 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71100575)
	e2:SetCondition(c71100575.spcon) 
	e2:SetTarget(c71100575.sptg)
	e2:SetOperation(c71100575.spop)
	c:RegisterEffect(e2)
end
function c71100575.ctcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsCanAddCounter(0x17d7,7)
end
function c71100575.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.Hint(HINT_CARD,0,71100575)
	c:AddCounter(0x17d7,7)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(71100102) 
	e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e2) 
end
function c71100575.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end 
function c71100575.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x7d8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c71100575.tgfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave() 
end 
function c71100575.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c71100575.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingTarget(c71100575.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c71100575.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71100575.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function c71100575.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetMZoneCount(tp)<1 then return end 
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c71100575.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		local sg=Duel.SelectMatchingCard(tp,c71100575.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT) 
	end 
end




