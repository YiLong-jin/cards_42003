--堕香之泪·泪滴花束雪花莲
function c9879083.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),8,3)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c9879083.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9879083.spcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)


	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879083,0))
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetHintTiming(0,TIMING_END_PHASE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,9879083)
	e12:SetCost(c9879083.thcost)
	e12:SetTarget(c9879083.target)
	e12:SetOperation(c9879083.operation)
	c:RegisterEffect(e12)


	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9879083,1))
	e13:SetType(EFFECT_TYPE_QUICK_O) 
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetHintTiming(0,TIMING_END_PHASE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,9879083)
	e13:SetCost(c9879083.cost1)
	e13:SetOperation(c9879083.desop)
	c:RegisterEffect(e13)
end
function c9879083.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end

function c9879083.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.CheckLPCost(tp,2000) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,2000)
end
function c9879083.filter(c)
	return c:IsCanOverlay()
end
function c9879083.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c9879083.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c9879083.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c9879083.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c9879083.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end


function c9879083.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) and Duel.CheckLPCost(tp,2000) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
	Duel.PayLPCost(tp,2000)
end
function c9879083.desop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_IMMUNE_EFFECT)   
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(function(e,te) 
		return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)
		local e12=Effect.CreateEffect(c) 
		e12:SetType(EFFECT_TYPE_SINGLE) 
		e12:SetCode(EFFECT_UPDATE_ATTACK)  
		e12:SetRange(LOCATION_MZONE) 
		e12:SetValue(2800) 
		e12:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e12) 
		local e13=Effect.CreateEffect(c) 
		e13:SetType(EFFECT_TYPE_SINGLE) 
		e13:SetCode(EFFECT_UPDATE_DEFENSE)  
		e13:SetRange(LOCATION_MZONE) 
		e13:SetValue(2800) 
		e13:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e13) 
end
