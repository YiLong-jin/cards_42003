--黑十字帝国军
function c9877125.initial_effect(c)
	aux.AddXyzProcedure(c,nil,10,2,c9877125.ovfilter,aux.Stringid(9877125,0))
	c:EnableReviveLimit()   


	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c9877125.tg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	

	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(9877125,0)) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9877125) 
	e2:SetCost(c9877125.plcost)
	e2:SetTarget(c9877125.pltg) 
	e2:SetOperation(c9877125.plop) 
	c:RegisterEffect(e2) 

	
end
function c9877125.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_XYZ) and c:IsRank(5)
end

function c9877125.tg(e,c)  
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE)
end



function c9877125.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9877125.plfil(c)
	return c:IsCode(9877123) and not c:IsForbidden()	  
end 
function c9877125.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877125.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
end 
function c9877125.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877125.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	end 
end 