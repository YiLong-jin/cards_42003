--恐虐杀戮冠军
function c21400032.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6210),4,2)
	c:EnableReviveLimit() 
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400032) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA) end)
	e1:SetTarget(c21400032.thtg)
	e1:SetOperation(c21400032.thop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11400032) 
	e2:SetCost(c21400032.descost)
	e2:SetTarget(c21400032.destg)
	e2:SetOperation(c21400032.desop)
	c:RegisterEffect(e2)
end
function c21400032.thfilter(c)
	return c:IsCode(21400039) and c:IsAbleToHand()
end
function c21400032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400032.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400032.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400032.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21400032.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21400032.desfil(c) 
	return c:IsSetCard(0x6210) and c:IsType(TYPE_MONSTER) 
end 
function c21400032.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400032.desfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end 
function c21400032.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local dg=Duel.SelectMatchingCard(tp,c21400032.desfil,tp,LOCATION_DECK,0,1,1,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end 









