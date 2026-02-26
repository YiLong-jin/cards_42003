--驱动空天变身-救世主六宵
c9879364.kotian=true
function c9879364.initial_effect(c)
	aux.AddCodeList(c,9879202,9879208,9879363)
	c:EnableReviveLimit()

	aux.EnableChangeCode(c,9879363,LOCATION_EXTRA)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9879364.splimit)
	c:RegisterEffect(e0)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879364,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9879364)
	e2:SetCondition(c9879364.discon)
	e2:SetCost(c9879364.discost)
	e2:SetTarget(c9879364.distg)
	e2:SetOperation(c9879364.disop)
	c:RegisterEffect(e2)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c9879364.tg)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	
end

function c9879364.tg(e,c)  
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER)
end

function c9879364.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(9879208)
end

function c9879364.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9879364.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9879364.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9879364.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end