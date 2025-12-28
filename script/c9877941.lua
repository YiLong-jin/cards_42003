--小圆前辈
function c9877941.initial_effect(c)
	aux.AddCodeList(c,9877934)  
	--code
	aux.EnableChangeCode(c,9877934,LOCATION_MZONE+LOCATION_GRAVE)
	--to hand sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,9877941)
	e1:SetTarget(c9877941.thstg) 
	e1:SetOperation(c9877941.thsop) 
	c:RegisterEffect(e1) 
end
function c9877941.thfil(c,tp) 
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0 
end 
function c9877941.thstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c9877941.thfil,tp,LOCATION_MZONE,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	local g=Duel.SelectTarget(tp,c9877941.thfil,tp,LOCATION_MZONE,0,1,1,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c9877941.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,1-tp,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  






