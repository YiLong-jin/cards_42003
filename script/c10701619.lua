--畸变价值
function c10701619.initial_effect(c)
	aux.AddCodeList(c,12644061)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701619+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701619.target)
	e1:SetOperation(c10701619.operation)
	c:RegisterEffect(e1)   
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12015000,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10701620)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10701619.thtg)
	e2:SetOperation(c10701619.thop)
	c:RegisterEffect(e2) 
end
function c10701619.filter(c)
	return c:IsSetCard(0x5034) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c10701619.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701619.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701619.gselect(g)
	return aux.dncheck(g) and g:GetClassCount(Card.GetLocation)==#g
end
function c10701619.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701619.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=cg:SelectSubGroup(tp,c10701619.gselect,false,1,math.min(ft,3))
	local tc=sg:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c10701619.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5034)
end
function c10701619.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701619.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	end
	local ct=Duel.GetMatchingGroupCount(c10701619.cfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c10701619.cfilter2(c)
	return c:IsCode(12644061) and c:IsFaceup()
end
function c10701619.setfilter(c)
	return c:IsCode(12644061) and not c:IsForbidden()
end
function c10701619.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.ConfirmDecktop(p,d)
	local g=Duel.GetDecktopGroup(p,d)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sc=g:Select(p,1,1,nil):GetFirst()
		if sc:IsAbleToHand() then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sc)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sc,REASON_RULE)
		end
	end
	if #g>1 then
		Duel.SortDecktop(tp,tp,#g-1)
		for i=1,#g-1 do
			local dg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(dg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	local g=Duel.GetMatchingGroup(c10701619.setfilter,tp,LOCATION_DECK,0,nil)
	if not Duel.IsExistingMatchingCard(c10701619.cfilter2,tp,LOCATION_FZONE,0,1,nil)
		and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(10701619,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end 