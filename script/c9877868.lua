--银月鬼杀式神术-阳炎咒
function c9877868.initial_effect(c)
	aux.AddCodeList(c,9877864,9877870)  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877868,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9877868.ckcon)
	e1:SetTarget(c9877868.target)
	e1:SetOperation(c9877868.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877868,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9877868)
	e2:SetCost(c9877868.thcost)
	e2:SetTarget(c9877868.thtg)
	e2:SetOperation(c9877868.thop)
	c:RegisterEffect(e2)
end 
function c9877868.ckfil1(c) 
	return c:IsFaceup() and aux.IsCodeListed(c,9877864)  
end  
function c9877868.ckfil2(c) 
	return c:IsFaceup() and c:IsCode(9877870)
end
function c9877868.ckcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c9877868.ckfil1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c9877868.ckfil2,tp,LOCATION_SZONE,0,1,nil) 
end 
function c9877868.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9877868.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if not Duel.IsExistingMatchingCard(c9877868.ckfil2,tp,LOCATION_SZONE,0,1,nil) then return end 
	if tc:IsRelateToEffect(e) then
		local x=0 
		if tc:IsDisabled() then x=1 end 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and x==1 and Duel.SelectYesNo(tp,aux.Stringid(9877868,0)) then 
			--activate limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1) 
			e1:SetValue(function(e,re,tp)
			return re:GetHandler():IsLocation(LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER) end) 
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end 
	end 
end
function c9877868.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9877868.thfilter(c)
	return c:IsCode(9877864) and c:IsAbleToHand()
end
function c9877868.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877868.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877868.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877868.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end






