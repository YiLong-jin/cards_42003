--神之梦——缚神之锁
function c22352134.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c22352134.condition2)
	e2:SetCountLimit(1,22352134)
	e2:SetCost(c22352134.cost)
	e2:SetTarget(c22352134.target2)
	e2:SetOperation(c22352134.activate2)
	c:RegisterEffect(e2)
end

function c22352134.cfilter(c)
	return c:IsSetCard(0xc29) and c:IsType(TYPE_LINK)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c22352134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22352134.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c22352134.cfilter,1,1,REASON_COST,true,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function c22352134.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c22352134.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22352134.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
