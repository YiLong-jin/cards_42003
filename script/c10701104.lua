--高速魔法－冲夺
function c10701104.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10701104.condition)
	e1:SetTarget(c10701104.target)
	e1:SetOperation(c10701104.activate)
	c:RegisterEffect(e1)	
end
function c10701104.condition(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x104d)>=6
end
function c10701104.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c10701104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10701104.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701104.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c10701104.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c10701104.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end