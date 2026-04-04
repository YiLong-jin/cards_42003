--危险等级A-亡魂龙
function c9877371.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()   
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,9877371)
	e1:SetCost(c9877371.descost)
	e1:SetTarget(c9877371.destg)
	e1:SetOperation(c9877371.desop)
	c:RegisterEffect(e1)	
	--set and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,1877371)   
	e2:SetCondition(function(e)  
	local re=e:GetHandler():GetReasonEffect()
	return re and e:GetHandler():IsReason(REASON_EFFECT) end)
	e2:SetTarget(c9877371.setdtg) 
	e2:SetOperation(c9877371.setdop) 
	c:RegisterEffect(e2)  
end
function c9877371.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9877371.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,TYPE_MONSTER) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c9877371.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if tc then 
		local x=Duel.Destroy(tc,REASON_EFFECT)
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,TYPE_MONSTER) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,TYPE_MONSTER) 
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end
end
function c9877371.setfil(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x27e4) 
end 
function c9877371.setdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877371.setfil,tp,LOCATION_DECK,0,1,nil) end  
end 
function c9877371.setdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877371.setfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		local x=Duel.SSet(tp,sc)
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(9877371,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER) 
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end  
end 