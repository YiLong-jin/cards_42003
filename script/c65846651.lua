--幻星集的宝剑 编号I
function c65846651.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846651,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65846651)
	e1:SetCost(c65846651.thcost)
	e1:SetTarget(c65846651.eqtg)
	e1:SetOperation(c65846651.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846651,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65846651)
	e2:SetCost(c65846651.thcost)
	e2:SetTarget(c65846651.eqtg)
	e2:SetOperation(c65846651.eqop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c65846651.eftg1)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c65846651.eftg2)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
end
function c65846651.cfilter(c,tp)
	return  (c:IsSetCard(0x3eb) or c:IsType(TYPE_EQUIP)) and c:IsAbleToGraveAsCost()
end
function c65846651.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then loc=LOCATION_SZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c65846651.cfilter,tp,loc,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846651.cfilter,tp,loc,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65846651.filter(c,ec,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3eb) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() 
end
function c65846651.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846651.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65846651.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65846651,1))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846651.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c,tp)
	if g:GetCount()>0 and Duel.Equip(tp,g:GetFirst(),c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(c65846651.eqlimit)
		g:GetFirst():RegisterEffect(e1)
	end
end
function c65846651.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c65846651.eftg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and not c:IsOriginalCodeRule(65846650) and not c:GetEquipGroup():IsExists(function(c) return  c:IsOriginalCodeRule(65846650) end,1,nil) 
end
function c65846651.eftg2(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and (c:GetEquipGroup():IsExists(function(c) return c:IsOriginalCodeRule(65846650) end,1,nil) or c:IsOriginalCodeRule(65846650))
end