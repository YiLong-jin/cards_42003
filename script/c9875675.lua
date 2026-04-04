--阿尔德利亚总督-莉可
function c9875675.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--to deck 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9875675,2))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,9875675) 
	e1:SetTarget(c9875675.tdtg) 
	e1:SetOperation(c9875675.tdop) 
	c:RegisterEffect(e1) 
	--to grave and td 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9875675,3))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9875675)
	e2:SetTarget(c9875675.tgrtg) 
	e2:SetOperation(c9875675.tgrop)
	c:RegisterEffect(e2) 
end
function c9875675.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c9875675.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsCode(9875674) and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0x2ea7) end,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875675,0)) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToHand() and c:IsSetCard(0x2ea7) end,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end 
function c9875675.tgfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave() 
end 
function c9875675.tgrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875675.tgfil,tp,LOCATION_SZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9875675.tgfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c9875675.tgrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875675,1)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
	end 
end 












