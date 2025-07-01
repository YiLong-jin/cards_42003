--傲慢之壶
function c10701518.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701518+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701518.target)
	e1:SetOperation(c10701518.activate)
	c:RegisterEffect(e1)
end
function c10701518.cfilter(c)
	return ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)))
end
function c10701518.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701518.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	end
	local ct=Duel.GetMatchingGroupCount(c10701518.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if ct>5 then
		ct=5
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c10701518.activate(e,tp,eg,ep,ev,re,r,rp)
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
end