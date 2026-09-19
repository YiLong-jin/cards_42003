--黎明圣地·沥水守护豚
function c9879438.initial_effect(c)
	aux.AddCodeList(c,9879431)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1eac),4,2)
	c:EnableReviveLimit() 
	
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9879438,0)) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,9879438) 
	e1:SetCost(c9879438.atkcost)
	e1:SetTarget(c9879438.atktg) 
	e1:SetOperation(c9879438.atkop) 
	c:RegisterEffect(e1)  
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9879438.desreptg)
	e2:SetValue(c9879438.desrepval)
	e2:SetOperation(c9879438.desrepop)
	c:RegisterEffect(e2)
end
function c9879438.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9879438.atkfil(c)
	return c:IsFaceup() and (c:IsSetCard(0x1eac) or c:IsCode(9879431)) 
end 
function c9879438.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879438.atkfil,tp,LOCATION_MZONE,0,1,nil) end 
end 
function c9879438.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879438.atkfil,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_UPDATE_DEFENSE)  
	tc:RegisterEffect(e2)
	tc=g:GetNext() 
	end 
end 
function c9879438.repfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x1eac) or c:IsCode(9879431)) 
	 and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9879438.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c9879438.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return true 
end
function c9879438.desrepval(e,c)
	return c9879438.repfilter(c,e:GetHandlerPlayer())
end
function c9879438.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,9879438)
end