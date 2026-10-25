--巫女黑江
function c9878623.initial_effect(c)
	aux.AddCodeList(c,9877918)

	aux.EnableChangeCode(c,9877918,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,9878623) 
	e1:SetTarget(c9878623.sptg) 
	e1:SetOperation(c9878623.spop) 
	c:RegisterEffect(e1)  

end
function c9878623.tgfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end 
function c9878623.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c9878623.tgfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,c9878623.tgfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end 
function c9878623.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
	end 
end 