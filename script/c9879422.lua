--一番合戦初命·炎神
function c9879422.initial_effect(c)
	aux.AddCodeList(c,9879421)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9879421,c9879422.fusfilter2,3,true,true)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit) 
	e0:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e0)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(c9879422.atkfilter)
	c:RegisterEffect(e4)
	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879422,1))
	e12:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e12:SetCode(EVENT_CHAINING)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,9879422)
	e12:SetCondition(c9879422.negcon)
	e12:SetCost(c9879422.negcost)
	e12:SetTarget(c9879422.negtg)
	e12:SetOperation(c9879422.negop)
	c:RegisterEffect(e12)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879422,0))
	e11:SetCategory(CATEGORY_EQUIP)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,9879422)
	e11:SetCost(c9879422.eqcost)
	e11:SetTarget(c9879422.eqtg)
	e11:SetOperation(c9879422.eqop)
	c:RegisterEffect(e11)

end
function c9879422.fusfilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c9879422.atkfilter(e,c)
	return c:IsDefensePos()
end

function c9879422.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c9879422.cfilter(c)
	return c:GetOriginalType()&(TYPE_MONSTER)==TYPE_MONSTER and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c9879422.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879422.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9879422.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9879422.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9879422.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end





function c9879422.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9879422.filter(c)
	return  c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9879422.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9879422.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9879422.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9879422.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9879422.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9879422.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c9879422.eqlimit(e,c)
	return c==e:GetOwner()
end