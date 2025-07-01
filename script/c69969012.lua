--五颜六色的小小鸟
function c69969012.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969012,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,69969012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c69969012.target)
	e1:SetOperation(c69969012.activate)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c69969012.reccon)
	e2:SetOperation(c69969012.recop)
	c:RegisterEffect(e2)
end
function c69969012.filter(c)
	return c:IsSetCard(0x699) and c:IsLevel(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c69969012.tdfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck() and c:IsSetCard(0x699)
end
function c69969012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969012.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c69969012.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,300)
end
function c69969012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c69969012.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c69969012.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()~=0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Damage(tp,300,REASON_EFFECT)
	else
		Duel.ShuffleHand(tp)
	end
end
--2
function c69969012.cfilter(c,tp)
	return c:IsSetCard(0x699)
end
function c69969012.reccon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(c69969012.cfilter,1,nil,1-tp)
end
function c69969012.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,69969012)
	Duel.Recover(tp,500,REASON_EFFECT)
end
