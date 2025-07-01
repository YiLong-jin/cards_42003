--椿
function c10000113.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,10000113) 
	e1:SetTarget(c10000113.sptg) 
	e1:SetOperation(c10000113.spop) 
	c:RegisterEffect(e1) 
end
function c10000113.spfil(c,e,tp,chken) 
	return c:IsSetCard(0xafe0) and not c:IsType(TYPE_TUNER) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c10000113.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and chken or c:IsAbleToGrave() and c:IsType(0x1))
end 
function c10000113.espfil(c,e,tp,sc) 
	local g=Group.FromCards(e:GetHandler(),sc)
	return c:IsSetCard(0xafe0) and c:IsSynchroSummonable(nil,g) 
end 
function c10000113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chken=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(c10000113.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,chken) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
end 
function c10000113.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local chken=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c10000113.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,chken)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and chken and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1152,1191)==0) then
		local ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		if ct>0 and c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c10000113.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) then 
			Duel.BreakEffect() 
			local mg=Group.FromCards(c,tc) 
			local sc=Duel.SelectMatchingCard(tp,c10000113.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst() 
			Duel.SynchroSummon(tp,sc,nil,mg)   
		end 
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end 
end 