--交响曲·四季·春
function c69969238.initial_effect(c)
 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969238,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e2:SetCountLimit(1,69969238)
	e2:SetCost(c69969238.thcost)
	e2:SetCondition(c69969238.cnacon)
	e2:SetTarget(c69969238.thtg)
	e2:SetOperation(c69969238.thop)
	c:RegisterEffect(e2)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969238,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,69969241)
	e1:SetCondition(c69969238.negcon)
	e1:SetTarget(c69969238.target)
	e1:SetOperation(c69969238.operation)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969238,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c69969238.nacon)
	e3:SetCost(c69969238.nacost)
	e3:SetTarget(c69969238.natg)
	e3:SetOperation(c69969238.naop)
	c:RegisterEffect(e3)
end
--1
function c69969238.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c69969238.cnacon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS) or 
		   (e:GetHandler():GetLocation()==LOCATION_HAND)
end
function c69969238.filter(c)
	return c:IsSetCard(0x669b) and c:IsAbleToHand() 
end
function c69969238.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969238.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69969238.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969238.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--2
function c69969238.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x669b) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c69969238.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c69969238.negfilter,1,nil,tp) 
end
function c69969238.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c69969238.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	   local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)	
		Duel.BreakEffect()
		if c:IsCanAddCounter(0x169b,2) then c:AddCounter(0x169b,2) end 
	end
end
--3
function c69969238.nacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c69969238.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x169b,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x169b,3,REASON_COST)
end
function c69969238.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.GetAttacker()
	if chk==0 then return b and b:IsRelateToBattle() and b:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,b:GetAttack())
end
function c69969238.naop(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttacker()
	if Duel.NegateAttack() and b and b:IsRelateToBattle() and b:IsFaceup() then
		Duel.Recover(tp,b:GetAttack()/2,REASON_EFFECT)
	end
end














