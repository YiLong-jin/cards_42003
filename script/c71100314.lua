--秘源异术 守护天灵
function c71100314.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c71100314.condition)
	e1:SetTarget(c71100314.target)
	e1:SetOperation(c71100314.activate)
	c:RegisterEffect(e1)  
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,71100314) 
	e2:SetCost(c71100314.thcost)
	e2:SetTarget(c71100314.thtg) 
	e2:SetOperation(c71100314.thop) 
	c:RegisterEffect(e2)
end
function c71100314.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c71100314.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c71100314.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7de))
	e1:SetValue(c71100314.efilter)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	Duel.RegisterEffect(e1,tp)
end
function c71100314.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
function c71100314.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end 
function c71100314.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x7de)
end 
function c71100314.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c71100314.thfil,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,c71100314.thfil,tp,LOCATION_GRAVE,0,2,2,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c71100314.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local sg=g:Filter(Card.IsRelateToEffect,nil,e) 
	if sg:GetCount()>0 then 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end 
end 











