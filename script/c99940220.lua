--情怀的慰问
function c99940220.initial_effect(c)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	aux.EnablePendulumAttribute(c)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(99940220,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_LSCALE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCondition(c99940220.sccon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e1)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99940220,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c99940220.sccon)
	e2:SetTarget(c99940220.target)
	e2:SetOperation(c99940220.operation)
--	c:RegisterEffect(e2)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99940210,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c99940220.pencon)
	e3:SetTarget(c99940220.pentg)
	e3:SetOperation(c99940220.penop)
	c:RegisterEffect(e3)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
end
function c99940220.sccon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),99940210) or Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),99940300)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function c99940220.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
end
function c99940220.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c99940220.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99940220.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99940220.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c99940220.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c99940220.valcon)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c99940220.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function c99940220.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99940220.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c99940220.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
