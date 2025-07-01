--邂逅于刹那芳华
function c10700783.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7cc))
	c:RegisterEffect(e2) 
	--bounce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700783,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10700783.atcon)
	e3:SetOperation(c10700783.atop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700783,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10700783.atcon2)
	e4:SetOperation(c10700783.atop2)
	c:RegisterEffect(e4)
end
function c10700783.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if d:IsControler(tp) then
		e:SetLabelObject(a)
		return d:IsSetCard(0x7cc)
			and a:IsRelateToBattle() and a:IsLocation(LOCATION_ONFIELD)
	elseif a:IsControler(tp) then
		e:SetLabelObject(d)
		return a:IsSetCard(0x7cc)
			and d:IsRelateToBattle() and d:IsLocation(LOCATION_ONFIELD)
	end
	return false
end
function c10700783.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c10700783.atcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if d:IsControler(tp) then
		e:SetLabelObject(d)
		return d:IsSetCard(0x7cc)
			and a:IsRelateToBattle() and a:IsLocation(LOCATION_ONFIELD)
	elseif a:IsControler(tp) then
		e:SetLabelObject(a)
		return a:IsSetCard(0x7cc)
			and d:IsRelateToBattle() and d:IsLocation(LOCATION_ONFIELD)
	end
	return false
end
function c10700783.atop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and Duel.GetTurnPlayer()==tp then
		Duel.ChainAttack(tc)
	end
end