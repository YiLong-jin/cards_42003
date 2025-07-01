--逐火之蛾的领袖 邦娅
function c9999950.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9999950)
	e1:SetTarget(c9999950.sptg)
	e1:SetOperation(c9999950.spop)
	c:RegisterEffect(e1)
end
function c9999950.thfilter(c)
	return c:IsAbleToHand()
end
function c9999950.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=LOCATION_ONFIELD 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then loc=LOCATION_MZONE end
	if chkc then return chkc:IsLocation(loc) and chkc:IsControler(tp) and c9999950.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9999950.thfilter,tp,loc,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,loc,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9999950.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end