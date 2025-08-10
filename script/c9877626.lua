--黑骑士小队轮舞一击
function c9877626.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877626,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9877626+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9877626.condition1)
	e2:SetTarget(c9877626.target1)
	e2:SetOperation(c9877626.activate1)
	c:RegisterEffect(e2)


end
function c9877626.filter11(c)
	return c:IsFaceup() and c:IsSetCard(0x17ec) 
end

function c9877626.condition1(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.IsExistingMatchingCard(c9877626.filter11,tp,LOCATION_MZONE,0,1,nil)
end
function c9877626.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877626.filter11,tp,LOCATION_MZONE,0,1,nil) end
end
function c9877626.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9877626.filter11,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9877626,1)) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if Duel.CheckLPCost(tp,2500) and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877626,0)) then
		Duel.PayLPCost(tp,2500)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
	end
end