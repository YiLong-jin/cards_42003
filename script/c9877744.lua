--首里和村正 向威风起誓
function c9877744.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c9877744.synfilter,aux.NonTuner(c9877744.synfilter1),nil,aux.NonTuner(c9877744.synfilter2),1,99)

	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)   
	e0:SetCondition(c9877744.lmcon)
	c:RegisterEffect(e0)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c9877744.efilter1)
	e3:SetValue(1)
	c:RegisterEffect(e3)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877744,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,9877744)
	e2:SetCondition(c9877744.negcon)
	e2:SetCost(c9877744.negcost)
	e2:SetTarget(c9877744.negtg)
	e2:SetOperation(c9877744.negop)
	c:RegisterEffect(e2)

end
function c9877744.efilter1(e,c)
	return c:IsType(TYPE_EQUIP)
end
function c9877744.synfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c9877744.synfilter1(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO)
end
function c9877744.synfilter2(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE)
end

function c9877744.lmcon(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA)	
end 



function c9877744.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev)
end
function c9877744.cfilter(c)
	return c:GetType()&(TYPE_EQUIP)==TYPE_EQUIP and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function c9877744.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877744.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9877744.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9877744.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9877744.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
