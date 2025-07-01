--高速魔咒－同调去除
function c10701108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10701108.condition)
	e1:SetTarget(c10701108.target)
	e1:SetOperation(c10701108.activate)
	c:RegisterEffect(e1)	
end
function c10701108.condition(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x104d)>=2
end
function c10701108.filter(c,check)
	return c:IsControlerCanBeChanged(check) and c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c10701108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c10701108.filter,tp,0,LOCATION_MZONE,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c10701108.filter2(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c10701108.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c10701108.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end