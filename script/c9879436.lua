--黎明圣地·怪异蛋
function c9879436.initial_effect(c)
	aux.AddCodeList(c,9879431)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9879436+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9879436.spcon)
	e1:SetTarget(c9879436.target)
	e1:SetOperation(c9879436.activate)
	c:RegisterEffect(e1)
end
function c9879436.filter(c)
	return c:IsDefense(400) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9879436.cfilter(c)
	return c:IsFaceup() and  c:IsCode(9879431)   
end
function c9879436.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879436.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9879436.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879436.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879436.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879436.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end