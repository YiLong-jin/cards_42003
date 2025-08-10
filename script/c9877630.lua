--黑骑士小队蓄力
function c9877630.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877630,1))
	e2:SetCategory(EFFECT_UPDATE_ATTACK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9877630+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9877630.cost1)
	e2:SetTarget(c9877630.atktg)
	e2:SetOperation(c9877630.atkop)
	c:RegisterEffect(e2)


end

function c9877630.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9877630.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end
function c9877630.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x17ec)
end
function c9877630.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877630.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877630.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9877630.atkfilter,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(c9877630.tgfil1,tp,LOCATION_DECK,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(9877630,1))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(500)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	if g1:GetCount()>0 and Duel.CheckLPCost(tp,2000)  and Duel.SelectYesNo(tp,aux.Stringid(9877630,0)) then 
			Duel.PayLPCost(tp,2000)
			local xg=g1:Select(tp,1,1,nil) 
			Duel.SendtoHand(xg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,xg)
	end  
end