--方解式指令执行人·阿斯卡纶
function c73116927.initial_effect(c)
----------------------------------------------------------------------------------------------------------------------------------------
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,99,c73116927.lcheck)
	c:EnableReviveLimit()
----------------------------------------------------------------------------------------------------------------------------------------
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73116927,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,73116927)
	e2:SetTarget(c73116927.destg)
	e2:SetOperation(c73116927.desop)
	e2:SetCondition(c73116927.descon)
	c:RegisterEffect(e2)
----------------------------------------------------------------------------------------------------------------------------------------
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73116927,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,83116927)
	e3:SetCondition(c73116927.immcon)
	e3:SetOperation(c73116927.immop)
	c:RegisterEffect(e3)
----------------------------------------------------------------------------------------------------------------------------------------
end
function c73116927.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x7ac)
end
function c73116927.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c73116927.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c73116927.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c73116927.immcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c73116927.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c73116927.efilter)
		e1:SetLabel(re:GetActiveType())
		c:RegisterEffect(e1)
	end
end
function c73116927.efilter(e,te)
	return te:IsActiveType(e:GetLabel()) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end