--「80年代的勒索者」
c40802021.RR_ZXESZ=true
function c40802021.initial_effect(c)
		
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40802021,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING) 
	e4:SetCondition(c40802021.discon)
	e4:SetTarget(c40802021.distg)
	e4:SetOperation(c40802021.disop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40802021,1))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c40802021.discon)
	e5:SetCost(c40802021.spcost)
	e5:SetTarget(c40802021.distg)
	e5:SetOperation(c40802021.disop1)
	c:RegisterEffect(e5)

	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40802021,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,40802021)
	e2:SetCondition(c40802021.thcon)
	e2:SetTarget(c40802021.thtg1)
	e2:SetOperation(c40802021.thop1)
	c:RegisterEffect(e2)

end
function c40802021.costfilter(c)
	return c:GetControler()~=c:GetOwner() and c:IsDiscardable()
end
function c40802021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40802021.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c40802021.costfilter,1,1,REASON_COST+REASON_DISCARD)
end


function c40802021.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)  
end

function c40802021.distg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c40802021.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c40802021.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoHand(eg,tp,REASON_EFFECT)
	end
end


function c40802021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c40802021.thfilter(c)
	return c.RR_ZXESZ and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToHand() and not c:IsCode(40802021)
end
function c40802021.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40802021.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40802021.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40802021.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end