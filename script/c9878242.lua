--知晓痛苦 所以悼念
function c9878242.initial_effect(c)
	aux.AddCodeList(c,9877896,9877905,9877906,9878242)
	c:SetUniqueOnField(1,0,9878242)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9878242+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)


	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c9878242.negcon)
	e3:SetOperation(c9878242.negop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)   
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9878242.sttg) 
	e4:SetOperation(c9878242.stop) 
	c:RegisterEffect(e4) 
end
function c9878242.cfil1(c)
	return c:IsFaceup() and (c:IsCode(9877905) or c:IsCode(9877906))
end
function c9878242.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return Duel.IsExistingMatchingCard(c9878242.cfil1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and c:GetFlagEffect(9878242)==0 and rc:IsDefensePos()
end
function c9878242.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(9878242,1)) then
		Duel.Hint(HINT_CARD,0,9878242)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(9878242,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end


function c9878242.stfil(c,tp)
	return aux.IsCodeListed(c,9877905) and c:IsType(TYPE_CONTINUOUS)
		and c:GetActivateEffect():IsActivatable(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c9878242.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878242.stfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end 
end
function c9878242.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9878242.stfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end 
	end
end