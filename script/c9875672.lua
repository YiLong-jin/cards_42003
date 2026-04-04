--击龙骑士-凯丽
function c9875672.initial_effect(c)
	aux.AddCodeList(c,9875667,9875671)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9875672) 
	e1:SetTarget(c9875672.sptg) 
	e1:SetOperation(c9875672.spop) 
	c:RegisterEffect(e1) 

	 local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9875672)
	e2:SetCost(c9875672.negcost)
	e2:SetTarget(c9875672.thtg)
	e2:SetOperation(c9875672.thop)
	c:RegisterEffect(e2)
end 
function c9875672.ckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)   
end 
function c9875672.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875672.ckfil,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	local g=Duel.SelectTarget(tp,c9875672.ckfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c9875672.plfil(c) 
	return c:IsCode(9875667) and not c:IsForbidden()	
end 
function c9875672.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsCode(9875671) and tc:IsAbleToGrave() and tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c9875672.plfil,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875672,0)) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then 
		local sc=Duel.SelectMatchingCard(tp,c9875672.plfil,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	end 
end 

function c9875672.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9875672.thfilter(c)
	return (c:IsCode(9875667) or (c:IsSetCard(0x2ea7) and c:IsType(TYPE_MONSTER))) and c:IsAbleToGrave()
end
function c9875672.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9875672.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9875672.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9875672.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end 
end