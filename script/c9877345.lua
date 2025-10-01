--薇特莉斯甜点工坊-雨天
function c9877345.initial_effect(c)
	 local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9877345,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,9877345+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9877345.actg1)
	e1:SetOperation(c9877345.acop1)
	c:RegisterEffect(e1) 

	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9877345.thtg)
	e2:SetOperation(c9877345.thop)
	c:RegisterEffect(e2)
end
function c9877345.acfil(c)
	return c:IsSetCard(0x17e4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end  
function c9877345.actg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877345.acfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877345.acop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877345.acfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 

function c9877345.thfilter(c)
	return c:IsSetCard(0x17e4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()  and c:IsFaceup() and not c:IsCode(9877345)
end
function c9877345.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877345.thfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_REMOVED)
end
function c9877345.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9877345.thfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end