--赛马娘梦的起点 特雷森
function c20003154.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x417))
	e2:SetValue(c20003154.atkval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(20003154,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,20003154)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c20003154.cost)
	e3:SetTarget(c20003154.target)
	e3:SetOperation(c20003154.activate)
	c:RegisterEffect(e3)

end


function c20003154.filterz(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x417)
end

function c20003154.atkval(e,c)
	return Duel.GetMatchingGroup(c20003154.filterz,c:GetControler(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*100
end






function c20003154.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and c:IsLevelBelow(4)
end
function c20003154.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20003154.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c20003154.cfilter,1,1,REASON_COST+REASON_DISCARD)
end





function c20003154.filter(c)
	return c:IsSetCard(0x417) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelBelow(4)
end
function c20003154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20003154.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20003154.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20003154.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end