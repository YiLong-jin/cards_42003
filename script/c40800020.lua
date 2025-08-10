--芝士 天偶
function c40800020.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40800020,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c40800020.thtg)
	e1:SetOperation(c40800020.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(40800020)
	e2:SetRange(LOCATION_MZONE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c40800020.efcon)
	e3:SetTarget(c40800020.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
c40800020.SetCard_RR_ZS=true 
function c40800020.eftg(e,c)
	local lg=e:GetHandler():GetLinkedGroup()
	return c:IsType(TYPE_XYZ) and c.SetCard_RR_ZS and lg:IsContains(c)
end
function c40800020.efcon(e)
	return Duel.GetOverlayGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0):FilterCount(Card.IsCode,nil,40800000)>=3
end
function c40800020.thfilter(c)
	return c.SetCard_RR_ZS and c:IsType(TYPE_MONSTER) and c:IsAttack(900) and c:IsAbleToHand()
end
function c40800020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40800020.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40800020.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40800020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end