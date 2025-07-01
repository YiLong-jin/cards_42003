--幻星集的宝剑 编号IX
function c65846659.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846659,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65846659)
	e1:SetCost(c65846659.thcost)
	e1:SetTarget(c65846659.thtg)
	e1:SetOperation(c65846659.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846659,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65846659)
	e2:SetCost(c65846659.thcost)
	e2:SetTarget(c65846659.thtg)
	e2:SetOperation(c65846659.thop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c65846659.eftg1)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c65846659.eftg2)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
end
function c65846659.cfilter(c)
	return  (c:IsSetCard(0x3eb) or c:IsType(TYPE_EQUIP)) and c:IsAbleToGraveAsCost()
end
function c65846659.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846659.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846659.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65846659.filter(c)
	return c:IsSetCard(0x3eb) and c:IsAbleToHand()
end
function c65846659.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846659.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65846659.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65846659.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65846659.eftg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and not c:IsOriginalCodeRule(65846650) and not c:GetEquipGroup():IsExists(function(c) return  c:IsOriginalCodeRule(65846650) end,1,nil) 
end
function c65846659.eftg2(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and (c:GetEquipGroup():IsExists(function(c) return c:IsOriginalCodeRule(65846650) and not c:IsDisabled() end,1,nil) or c:IsOriginalCodeRule(65846650) and not c:IsDisabled())
end