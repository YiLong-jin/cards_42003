--超时空紧急传输移动
function c71100165.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100165+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71100165.target)
	e1:SetOperation(c71100165.activate)
	c:RegisterEffect(e1)
end
function c71100165.tgfilter(c)
	return c:IsSetCard(0x7d9) and c:IsAbleToGrave()
end
function c71100165.thfilter(c,tc)
	return c:IsSetCard(0x7d9) and c:IsAbleToHand() and not c:IsCode(tc:GetCode())
end
function c71100165.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100165.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71100165.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c71100165.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.SelectYesNo(tp,aux.Stringid(71100165,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c71100165.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
