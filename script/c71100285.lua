--Atk up up up!
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(aux.bfgcost)
	e0:SetOperation(s.op)
	c:RegisterEffect(e0)
end
--e1
function s.op(e,tp,eg,ep,ev,re,r,rp)
	--atk up
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x17df))
	e1:SetLabel(0)
	e1:SetValue(function(ae,ac) return ae:GetLabel() end)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
	--check
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.ckcon)
	e2:SetOperation(s.ckop)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.ckcon(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabelObject():GetLabel()
	return ep==1-tp and val<1200
end
function s.ckop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local val=te:GetLabel()+300
	te:SetLabel(val)
end