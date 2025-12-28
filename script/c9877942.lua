--小圆前辈UP!!!
function c9877942.initial_effect(c)
	aux.AddCodeList(c,9877934,9877873)  
	--code
	aux.EnableChangeCode(c,9877934,LOCATION_MZONE+LOCATION_GRAVE)   
	--to hand sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,9877942)
	e1:SetTarget(c9877942.thstg) 
	e1:SetOperation(c9877942.thsop) 
	c:RegisterEffect(e1) 
end
function c9877942.thfil(c,tp) 
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0 
end 
function c9877942.filter(c)
	return aux.IsCodeListed(c,9877934) and c:IsAbleToHand()
end
function c9877942.thstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c9877942.thfil,tp,LOCATION_MZONE,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	local g=Duel.SelectTarget(tp,c9877942.thfil,tp,LOCATION_MZONE,0,1,1,nil,tp) 
	if g:GetFirst():IsCode(9877873) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0)
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c9877942.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local x=e:GetLabel()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and x==1 and Duel.IsExistingMatchingCard(c9877942.filter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877942,0)) then  
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,c9877942.filter,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end  






