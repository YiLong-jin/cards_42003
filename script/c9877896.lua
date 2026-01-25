--十咎桃子
function c9877896.initial_effect(c)
	 aux.AddCodeList(c,9877895,9877896,9877897)
	
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,9877896)
	e1:SetTarget(c9877896.thstg) 
	e1:SetOperation(c9877896.thsop) 
	c:RegisterEffect(e1) 

	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,1877896)
	e13:SetOperation(c9877896.desop)
	c:RegisterEffect(e13)
end
function c9877896.thfil(c,tp) 
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0 and (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) )  and c:IsFaceup()
end 
function c9877896.thstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9877896.thfil,tp,LOCATION_MZONE,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	local g=Duel.SelectTarget(tp,c9877896.thfil,tp,LOCATION_MZONE,0,1,1,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c9877896.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  


function c9877896.desop(e,tp,eg,ep,ev,re,r,rp)
		  local c=e:GetHandler()
		  local e1=Effect.CreateEffect(c) 
		  e1:SetType(EFFECT_TYPE_SINGLE) 
		  e1:SetCode(EFFECT_UPDATE_ATTACK)  
		  e1:SetRange(LOCATION_MZONE) 
		  e1:SetValue(500) 
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		  c:RegisterEffect(e1) 
end
