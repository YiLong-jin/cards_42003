--主力甄选
local m=65846701
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3ea) and c:IsAbleToHand()
end
function cm.thfilter2(c,lv,mc)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(mc) and c:IsAbleToHand() and (c:IsLevel(lv) and c:IsRace(RACE_PSYCHO) or c:IsSetCard(0x3ea) and not c:IsLevel(lv))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thtrfat(c)
	return c:IsCode(65846687) and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chken=Duel.IsExistingMatchingCard(cm.thtrfat,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local ct=Duel.SendtoHand(tc,nil,REASON_EFFECT)
	if ct==0 then return end
	Duel.ConfirmCards(1-tp,tc)
	local chkem=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	if chken and chkem and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetOriginalLevel(),tc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetOriginalLevel(),tc:GetCode())
		local tac=sg:GetFirst()
		if not tac then return end
		Duel.SendtoHand(tac,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tac)
	end
end