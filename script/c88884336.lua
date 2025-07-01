--灾难之变貌
function c88884336.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,88884336)
	e1:SetCondition(c88884336.condition1)
	e1:SetTarget(c88884336.target1)
	e1:SetOperation(c88884336.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--destory
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,88884336)
	e4:SetCondition(c88884336.descon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c88884336.destg)
	e4:SetOperation(c88884336.desop)
	c:RegisterEffect(e4)
end
function c88884336.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8895) and c:IsType(TYPE_FUSION)
end
function c88884336.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(c88884336.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88884336.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c88884336.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c88884336.filter(c)
	return c:IsSetCard(0x8895) and c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c88884336.descon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_MZONE)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x8895) and re:GetHandler():IsType(TYPE_FUSION)
end
function c88884336.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c88884336.filter,tp,LOCATION_MZONE,0,1,nil) end
	local ct1=Duel.GetMatchingGroupCount(c88884336.filter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	local mc=math.min(ct1,ct2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,mc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
end
function c88884336.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end