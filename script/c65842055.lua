--起始之星
function c65842055.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65842055+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65842055.cost)
	e1:SetTarget(c65842055.target)
	e1:SetOperation(c65842055.activate)
	c:RegisterEffect(e1)	
end
function c65842055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c65842055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return not c:IsRace(0x2) and c:IsAbleToHand() and ( c:IsType(TYPE_NORMAL) or c:IsCode(24094653,65842053)) end,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65842055.fselect(g)
	return g:FilterCount(function(c) return c:IsCode(24094653) end,nil)<=1 and g:FilterCount(function(c) return c:IsType(0x1) end,nil)<=1 
end
function c65842055.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c) return not c:IsRace(0x2) and c:IsAbleToHand() and (c:IsType(TYPE_NORMAL) or c:IsCode(24094653,65842053)) end,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c65842055.fselect,false,1,2,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end