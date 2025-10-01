--薇特莉斯甜点工坊-马卡龙蛋糕酱
function c9871037.initial_effect(c)
	c:SetUniqueOnField(1,0,9871037)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9871037,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9871037)
	e2:SetTarget(c9871037.thtg)
	e2:SetOperation(c9871037.thop)
	c:RegisterEffect(e2)
end
function c9871037.thfilter(c)
	return c:IsSetCard(0x17e4) and c:IsAbleToHand()
end
function c9871037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9871037.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9871037.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9871037.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end