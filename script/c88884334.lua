--龙树开花·天地终焉
function c88884334.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,88884334)
	e1:SetCondition(c88884334.con)
	e1:SetTarget(c88884334.target)
	e1:SetOperation(c88884334.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,88884334)
	e2:SetCondition(c88884334.atkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88884334.atktg)
	e2:SetOperation(c88884334.atkop)
	c:RegisterEffect(e2)
end
function c88884334.filter(c)
	return c:IsSetCard(0x8893) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c88884334.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c88884334.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c88884334.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c88884334.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if not Duel.IsExistingMatchingCard(c88884334.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c88884334.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	if Duel.Destroy(g1,REASON_EFFECT)>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c88884334.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8895)
end
function c88884334.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_MZONE)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x8895) and re:GetHandler():IsType(TYPE_FUSION)
end
function c88884334.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884334.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c88884334.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88884334.atkfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then 
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end