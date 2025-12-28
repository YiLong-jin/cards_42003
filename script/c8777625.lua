--猩红的幼月-蕾米莉亚
function c8777625.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8777625,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,8777625)
	e1:SetTarget(c8777625.thtg)
	e1:SetOperation(c8777625.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c8777625.spfilter(c,e,tp)
	return c:IsSetCard(0x1ea1) and c:IsAbleToHand()
end
function c8777625.tgfilter(c)
	return c:IsSetCard(0x8e) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c8777625.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777625.spfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c8777625.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c8777625.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8777625.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0  then
		local g1=Duel.SelectMatchingCard(tp,c8777625.spfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end 
end