--Doro 刹停
function c69969457.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969457,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,69969457)
	e1:SetCondition(c69969457.descon)
	e1:SetTarget(c69969457.target)
	e1:SetOperation(c69969457.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969457,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,69969457)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c69969457.sptg)
	e2:SetOperation(c69969457.spop)
	c:RegisterEffect(e2)
end
function c69969457.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x69e) and rp==tp
end
function c69969457.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c69969457.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if (te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER))
			then Duel.NegateActivation(i) 
end
end end
--2
function c69969457.tfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x69e) and c:IsFaceup() and not c:IsCode(69969457) and Duel.IsExistingMatchingCard(c69969457.tgfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c69969457.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x69e) and c:IsAbleToRemove()
end
function c69969457.tgfilter2(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x69e) and c:IsAbleToRemove()
end
function c69969457.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and c69969457.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969457.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c69969457.tfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c69969457.rmfilter(c)
	return  c:IsAbleToRemove()
end
function c69969457.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local type1=tc:GetType()&0x7
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c69969457.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type1)
		local tgc=g:GetFirst()
		if tgc and Duel.Remove(tgc,POS_FACEUP,REASON_EFFECT)~=0 and tgc:IsLocation(LOCATION_REMOVED) and Duel.IsExistingMatchingCard(c69969457.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(69969457,2)) then
		Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,c69969457.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			local rmtc=sg:GetFirst()
			Duel.Remove(rmtc,POS_FACEUP,REASON_EFFECT)
				
			end
		end
	end