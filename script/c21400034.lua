--恐虐嗜血大魔
function c21400034.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),8,3,c21400034.ovfilter,aux.Stringid(10443957,0),3)
	c:EnableReviveLimit()
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21400034) 
	e1:SetCondition(function(e) 
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e1:SetTarget(c21400034.atktg)
	e1:SetOperation(c21400034.atkop)
	c:RegisterEffect(e1) 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c21400034.actcon)
	e2:SetValue(c21400034.actlimit)
	c:RegisterEffect(e2) 
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function(e,c) 
	return not c:IsSetCard(0x6210) end) 
	c:RegisterEffect(e3)
end
function c21400034.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6210) and c:IsRank(4) 
end
function c21400034.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local x=e:GetHandler():RemoveOverlayCard(tp,1,99,REASON_COST) 
	e:SetLabel(x)
end
function c21400034.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel() 
	if c:IsRelateToEffect(e) and x>=2 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(x-1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end 
end 
function c21400034.actcon(e)
	local tp=e:GetHandler():GetControler()
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) 
end
function c21400034.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
end




