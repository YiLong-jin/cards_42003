--死亡加速器
function c10701111.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c10701111.condition)
	e1:SetTarget(c10701111.target)
	e1:SetOperation(c10701111.operation)
	c:RegisterEffect(e1)	
end
function c10701111.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c10701111.ctfilter(c)
	return c:IsFaceup()
end
function c10701111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local d=math.floor(ev/300)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and c10701111.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701111.ctfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectTarget(tp,c10701111.ctfilter,tp,LOCATION_FZONE,0,1,1,nil)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c10701111.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and d>0 then
		tc:AddCounter(0x104d,d,true)
	end
end