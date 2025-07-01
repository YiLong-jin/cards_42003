--死灵舞者 狼人
function c71100579.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),3,2)
	c:EnableReviveLimit() 
	--direct 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100579,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c71100579.drtcon)
	e1:SetCost(c71100579.drtcost)
	e1:SetOperation(c71100579.drtop)
	c:RegisterEffect(e1)
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100579,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c71100579.atktg)
	e2:SetOperation(c71100579.atkop)
	c:RegisterEffect(e2)
end
function c71100579.drtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
end 
function c71100579.drtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71100579.drtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler()) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end 
function c71100579.ctfil(c) 
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) 
end 
function c71100579.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetOverlayGroup(tp,1,0):Filter(c71100579.ctfil,nil) 
	if chk==0 then return g:GetCount()>0 end 
end
function c71100579.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetOverlayGroup(tp,1,0):Filter(c71100579.ctfil,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(e:GetHandler()) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.abs(c:GetBaseAttack()-tc:GetBaseAttack()))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end 
	end 
end 








