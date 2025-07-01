--调停
function c69969013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969013,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,69969013)
	e1:SetCondition(c69969013.condition)
	e1:SetTarget(c69969013.target)
	e1:SetOperation(c69969013.activate)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,69969013)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c69969013.thtg)
	e2:SetOperation(c69969013.thop)
	c:RegisterEffect(e2)
end
function c69969013.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x699)
end
function c69969013.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(c69969013.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c69969013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local b1=Duel.IsChainDisablable(ev)
	local b2=rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EXTRA,0,1,nil,69969013) then
			op=Duel.SelectOption(tp,aux.Stringid(69969013,1),aux.Stringid(69969013,2),aux.Stringid(69969013,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(69969013,1),aux.Stringid(69969013,2))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(69969013,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(69969013,2))+1
	end
	e:SetLabel(op)
	if op~=0 then
		if op==1 then
			e:SetCategory(CATEGORY_REMOVE)
		else
			e:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
		end
		if rc:IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		end
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
end
function c69969013.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local res=0
	if op~=1 then
		Duel.NegateEffect(ev)
	end
	if op~=0 then
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(re) then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c69969013.thfilter(c)
	return c:IsSetCard(0x699) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c69969013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69969013.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69969013.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c69969013.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c69969013.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
