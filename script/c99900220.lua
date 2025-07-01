--风见野魔法少女 佐仓杏子
function c99900220.initial_effect(c)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99900220,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c99900220.target)
	e3:SetOperation(c99900220.thop)
	c:RegisterEffect(e3)
end
function c99900220.filter(c)
	return c:IsSetCard(0x676) and c:IsLevelBelow(5) and c:IsAbleToHand() and not c:IsCode(99900220)
end
function c99900220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900220.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99900220.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99900220.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end