local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.gjfield(c)
	return c:IsFaceup() and c:IsCode(73116300)
end
function s.gjfilter(c)
	return c:IsCode(73116300) and c:IsAbleToHand()
end
function s.trapfilter(c)
	return c:IsSetCard(0x7bd) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(s.gjfilter,tp,LOCATION_DECK,0,1,nil) then return true end
		local hasgj=Duel.IsExistingMatchingCard(s.gjfield,tp,LOCATION_MZONE,0,1,nil)
		return hasgj and Duel.IsExistingMatchingCard(s.trapfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local gj=Duel.IsExistingMatchingCard(s.gjfilter,tp,LOCATION_DECK,0,1,nil)
	local hasgj=Duel.IsExistingMatchingCard(s.gjfield,tp,LOCATION_MZONE,0,1,nil)
	local trap=Duel.IsExistingMatchingCard(s.trapfilter,tp,LOCATION_DECK,0,1,nil)
	local opt=0
	if hasgj and trap and gj then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif hasgj and trap then
		opt=1
	end
	if opt==0 then
		if not gj then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.gjfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.trapfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and bit.band(r,REASON_DISCARD)~=0
end
function s.dis(c)
	return c:IsSetCard(0x7bd) and c:IsDiscardable()
end
function s.trapfilter2(c)
	return c:IsSetCard(0x7bd) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local a=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local b=a and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.trapfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		local c2=Duel.IsExistingMatchingCard(s.gjfield,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.dis,tp,LOCATION_HAND,0,1,nil)
		return a or b or c2
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ops={}
	local opval={}
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		ops[#ops+1]=aux.Stringid(id,4)
		opval[#opval+1]=0
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.trapfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		ops[#ops+1]=aux.Stringid(id,5)
		opval[#opval+1]=1
	end
	if Duel.IsExistingMatchingCard(s.gjfield,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.dis,tp,LOCATION_HAND,0,1,nil) then
		ops[#ops+1]=aux.Stringid(id,6)
		opval[#opval+1]=2
	end
	local opt=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[opt+1]
	if sel==0 then
		if c:IsRelateToEffect(e) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.trapfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,7))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,s.dis,tp,LOCATION_HAND,0,1,99,nil)
		if #g==0 then return end
		local ct=#g
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,s.gjfield,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			Duel.HintSelection(tg)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
