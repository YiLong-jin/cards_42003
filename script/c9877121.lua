--潘兴
function c9877121.initial_effect(c)
	
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9877121)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	e1:SetCondition(c9877121.descon1) 
	e1:SetTarget(c9877121.destg) 
	e1:SetOperation(c9877121.desop) 
	c:RegisterEffect(e1)   
	local e2=e1:Clone() 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetCondition(c9877121.descon2) 
	c:RegisterEffect(e2) 
end


function c9877121.spfilter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_LINK)
end
function c9877121.descon1(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c9877121.spfilter,tp,LOCATION_MZONE,0,1,nil) 
end 
function c9877121.descon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9877121.spfilter,tp,LOCATION_MZONE,0,1,nil) 
end 
function c9877121.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c9877121.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.Destroy(tc,REASON_EFFECT) 
	end 
end 