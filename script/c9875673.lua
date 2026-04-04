--原型魔石浮空船
function c9875673.initial_effect(c)
	aux.AddCodeList(c,9875669)
	--Special Summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9875673)
	e1:SetCondition(c9875673.sscon)
	e1:SetTarget(c9875673.sstg)
	e1:SetOperation(c9875673.ssop)
	c:RegisterEffect(e1)	 
	--to grave and sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1875673)   
	e2:SetTarget(c9875673.tgstg) 
	e2:SetOperation(c9875673.tgsop)
	c:RegisterEffect(e2)
end
function c9875673.filter(c)
	return c:IsFaceup() and c:IsCode(9875669) 
end
function c9875673.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9875673.filter,tp,LOCATION_SZONE,0,1,nil)
end
function c9875673.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9875673.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end 
function c9875673.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and c:IsSetCard(0x2ea7)   
end 
function c9875673.tgfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave() 
end 
function c9875673.tgstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingTarget(c9875673.tgfil,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c9875673.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c9875673.tgfil,tp,LOCATION_SZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end
function c9875673.tgsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c9875673.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and g:GetCount()>0 then 
		Duel.BreakEffect() 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9875673.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9875673.splimit(e,c)
	return not c:IsSetCard(0x2ea7) 
end















