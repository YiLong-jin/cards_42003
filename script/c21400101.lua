--色孽的闲暇时光
function c21400101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,21400101) 
	e1:SetCost(c21400101.cost)
	e1:SetTarget(c21400101.target)
	e1:SetOperation(c21400101.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,11400101)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c21400101.thtg)
	e2:SetOperation(c21400101.thop)
	c:RegisterEffect(e2)
end
function c21400101.pbfil(c) 
	return not c:IsPublic() and c:IsSetCard(0x5210) and c:IsType(TYPE_MONSTER) 
end 
function c21400101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400101.pbfil,tp,LOCATION_HAND,0,1,nil) end  
	local tc=Duel.SelectMatchingCard(tp,c21400101.pbfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst() 
	Duel.ConfirmCards(1-tp,tc) 
	e:SetLabelObject(tc)
end
function c21400101.filter(c)
	return c:IsSetCard(0x5210) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21400101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400101.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400101.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400101.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tc and tc:IsLocation(LOCATION_HAND) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21400101.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5210) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21400101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400101.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c21400101.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400101.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



