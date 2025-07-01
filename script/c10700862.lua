--精灵兽 森鹿
function c10700862.initial_effect(c)
	c:SetSPSummonOnce(10700862) 
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700862,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetCost(c10700862.cost)
	e1:SetTarget(c10700862.rmtg)
	e1:SetOperation(c10700862.rmop)
	c:RegisterEffect(e1)
end
function c10700862.cfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xb5)
end
function c10700862.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700862.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10700862.cfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10700862.thfilter(c)
	return c:IsSetCard(0xb5) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c10700862.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
end
function c10700862.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700862.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end