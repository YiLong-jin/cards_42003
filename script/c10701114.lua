--高速魔咒－召唤师的技艺
function c10701114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10701114.condition)
	e1:SetTarget(c10701114.target)
	e1:SetOperation(c10701114.activate)
	c:RegisterEffect(e1)
end
function c10701114.condition(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x104d)>=2
end
function c10701114.filter(c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c10701114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701114.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701114.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701114.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
