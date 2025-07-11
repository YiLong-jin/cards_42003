--为色孽干杯
function c21400074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	c:RegisterEffect(e1)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0x5210) end)
	e1:SetValue(function(e,c) 
	local tp=e:GetHandlerPlayer()
	local x=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	return math.floor(x/10) end) 
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,21400074)
	e2:SetCondition(c21400074.discon)
	e2:SetTarget(c21400074.distg)
	e2:SetOperation(c21400074.disop)
	c:RegisterEffect(e2)
end
function c21400074.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x5210) and p==tp and re:IsActiveType(TYPE_MONSTER) and rp==1-tp 
end
function c21400074.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c21400074.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then 
		Duel.NegateEffect(ev)
	end 
end

