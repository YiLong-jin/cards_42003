--慵懒的大贤者
function c9877586.initial_effect(c)
	aux.AddRitualProcEqual2(c,c9877586.ritual_filter)

	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,9877586)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9877586.thtg)
	e2:SetOperation(c9877586.thop)
	c:RegisterEffect(e2)
	
end
function c9877586.ritual_filter(c)
	return c:IsType(TYPE_RITUAL)
end

function c9877586.thfilter(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end
function c9877586.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877586.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877586.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877586.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end