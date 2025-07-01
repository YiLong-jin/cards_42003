--加速地带
function c10701110.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701110,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c10701110.condition)
	e1:SetTarget(c10701110.target)
	e1:SetOperation(c10701110.activate)
	c:RegisterEffect(e1)	
end
function c10701110.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_FIELD)
end
function c10701110.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x104d,6)
end
function c10701110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and c10701110.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701110.ctfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectTarget(tp,c10701110.ctfilter,tp,LOCATION_FZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c10701110.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x104d,6)
	end
end