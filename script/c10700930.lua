--イヴの対危害マガン＝カタ
function c10700930.initial_effect(c)
	aux.AddCodeList(c,10700890,10700895)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700930+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10700930.cost)
	e1:SetTarget(c10700930.target)
	e1:SetOperation(c10700930.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700930,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,10700931)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700930.thtg)
	e2:SetOperation(c10700930.thop)
	c:RegisterEffect(e2)   
end
function c10700930.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7cd)
end
function c10700930.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700930.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10700930.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c10700930.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND 
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700930.costfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c10700930.costfilter,tp,loc,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c10700930.cfilter1(c)
	return c:IsCode(10700890) and c:IsFaceup()
end
function c10700930.rmfilter(c,check)
	return c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_ONFIELD) and check
end
function c10700930.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsExistingMatchingCard(c10700930.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsAbleToRemove() and c10700930.rmfilter(chkc,check) end
	if chk==0 then return Duel.IsExistingTarget(c10700930.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,check) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10700930.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil,check)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c10700930.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c10700930.thfilter(c)
	return c:IsCode(10700895) and c:IsAbleToHand()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10700930.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c10700930.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700930.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700930.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10700930.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	 Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end