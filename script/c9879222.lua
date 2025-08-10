--核心列车 脉冲特警
c9879222.hxlc=true
function c9879222.initial_effect(c)
	aux.AddXyzProcedure(c,c9879222.mfilter,10,2)
	c:EnableReviveLimit()

	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c9879222.tg)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)


	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9879222,1))
	e5:SetCategory(EFFECT_UPDATE_ATTACK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,9879222)
	e5:SetCondition(c9879222.negcon)
	e5:SetCost(c9879222.negcost)
	e5:SetTarget(c9879222.sptg2)
	e5:SetOperation(c9879222.spop2)
	c:RegisterEffect(e5)
	
end
function c9879222.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end 

function c9879222.tg(e,c)  
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end


function c9879222.filter11(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_XYZ)
end
function c9879222.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9879222.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879222.filter11,tp,LOCATION_MZONE,0,1,nil)
end
function c9879222.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c9879222.filter11,tp,LOCATION_MZONE,0,1,nil) end
end
function c9879222.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9879222.filter11,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(9879222,3))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetValue(1000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
