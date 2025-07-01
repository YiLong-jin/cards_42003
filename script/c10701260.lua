--奈芙提斯之转生
function c10701260.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c10701260.filter,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,nil,nil,true)
	e1:SetDescription(aux.Stringid(10701260,0))
	e1:SetCountLimit(1,10701260+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701260,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10701261)
	e2:SetCondition(c10701260.descon)
	e2:SetTarget(c10701260.destg)
	e2:SetOperation(c10701260.desop)
	c:RegisterEffect(e2)  
end
function c10701260.filter(c,e,tp,chk)
	return c:IsSetCard(0x11f)
end
function c10701260.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x11f)
end
function c10701260.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10701260.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end