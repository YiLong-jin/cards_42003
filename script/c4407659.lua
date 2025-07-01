--聚集 妖精圆桌骑士！
function c4407659.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,4407659+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c4407659.target)
	e1:SetOperation(c4407659.activate)
	c:RegisterEffect(e1)
end 
function c4407659.filter(c,e,tp)
	return c:IsSetCard(0xd77) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4407659.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4407659.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c4407659.thfil(c,tc) 
	local race=tc:GetRace() 
	local lv=tc:GetLevel() 
	return c:IsSetCard(0xd77) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and bit.band(c:GetOriginalRace(),race)~=0 and c:IsLevelAbove(1) and not c:IsLevel(lv)   
end 
function c4407659.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c4407659.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetLabel(tc:GetRace())
	e1:SetTarget(c4407659.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c4407659.thfil,tp,LOCATION_DECK,0,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(4407659,0)) then 
	local sg=Duel.SelectMatchingCard(tp,c4407659.thfil,tp,LOCATION_DECK,0,1,1,nil,tc)
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
	end 
end
function c4407659.splimit(e,c)
	return not c:IsRace(e:GetLabel())
end













