--终末之火
function c88884205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c88884205.effectfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c88884205.effectfilter)
	c:RegisterEffect(e4)
	--add card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88884205,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c88884205.afcost)
	e5:SetCondition(c88884205.thcon)
	e5:SetTarget(c88884205.target)
	e5:SetOperation(c88884205.activate)
	c:RegisterEffect(e5)
end
function c88884205.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x882) and bit.band(loc,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)~=0
end
function c88884205.afcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c88884205.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,88884205)==0
end
function c88884205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c88884205.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,88884205)~=0 then return end
	Duel.RegisterFlagEffect(tp,88884205,0,0,0)
	local token1=Duel.CreateToken(tp,88884200)
	Duel.SendtoDeck(token1,nil,0,REASON_RULE)
	Duel.ConfirmDecktop(tp,1)
	local token2=Duel.CreateToken(tp,88884201)
	Duel.SendtoDeck(token2,nil,0,REASON_RULE)
	Duel.ConfirmDecktop(tp,1)
	local token3=Duel.CreateToken(tp,88884203)
	Duel.SendtoDeck(token3,nil,0,REASON_RULE)
	Duel.ConfirmDecktop(tp,1)
	local token4=Duel.CreateToken(tp,88884205)
	Duel.SendtoDeck(token4,nil,0,REASON_RULE)
	Duel.ConfirmDecktop(tp,1)
	local token5=Duel.CreateToken(tp,88884202)
	Duel.SendtoDeck(token5,nil,0,REASON_RULE)
	Duel.ConfirmCards(1-tp,token5)
	Duel.ShuffleDeck(tp)
end