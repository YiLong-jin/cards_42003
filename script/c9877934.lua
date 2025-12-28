--鹿目圆
function c9877934.initial_effect(c)
	aux.AddCodeList(c,9877934,9877873) 
	
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,9877934)
	e1:SetTarget(c9877934.thstg) 
	e1:SetOperation(c9877934.thsop) 
	c:RegisterEffect(e1) 

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877934,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,1877934)
	e3:SetCondition(c9877934.atcon)
	e3:SetTarget(c9877934.thtg)
	e3:SetOperation(c9877934.thop)
	c:RegisterEffect(e3)
	
end
function c9877934.thfil(c,tp) 
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0  and c:IsFaceup()
end 
function c9877934.thstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9877934.thfil,tp,LOCATION_MZONE,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	local g=Duel.SelectTarget(tp,c9877934.thfil,tp,LOCATION_MZONE,0,1,1,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c9877934.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  


function c9877934.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9877934.thfilter(c)
	return (aux.IsCodeListed(c,9877934) or aux.IsCodeListed(c,9877873) ) and c:IsAbleToHand()
end
function c9877934.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877934.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877934.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877934.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
