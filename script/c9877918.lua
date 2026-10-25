--黑江
function c9877918.initial_effect(c)
	 aux.AddCodeList(c,9877918,9877873) 

	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9877918,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9877918)
	e1:SetCondition(c9877918.spcon)
	e1:SetTarget(c9877918.sptg)
	e1:SetOperation(c9877918.spop)
	c:RegisterEffect(e1)
	

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877918,1))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_HAND)
	e11:SetCountLimit(1,9877918)
	e11:SetCost(c9877918.thcost)
	e11:SetTarget(c9877918.thtg)
	e11:SetOperation(c9877918.thop)
	c:RegisterEffect(e11) 
end
function c9877918.f(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9877873)
end
function c9877918.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9877918.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9877918.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877918.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end


function c9877918.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9877918.thfilter(c)
	return (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877918)) and c:IsAbleToHand()
end
function c9877918.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877918.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877918.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877918.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 