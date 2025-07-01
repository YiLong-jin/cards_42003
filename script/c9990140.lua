--逐火之蛾的曙光
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter1(c)
	return c:IsSetCard(0x669) and c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function s.filter(c)
	return c:IsSetCard(0x669) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.tdfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ch=Duel.GetCurrentChain()
	local b1=Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2})
	end
	e:SetLabel(op)
	if op==1 then
			Duel.SetTargetPlayer(tp)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_SZONE)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==2 then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local g=Duel.GetFieldGroup(p,LOCATION_SZONE,LOCATION_SZONE)
		local fg=g:Filter(s.filter,e:GetHandler())
		if fg:GetCount()==0 then return end
		Duel.SendtoGrave(fg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(p,fg:GetCount(),REASON_EFFECT)
	elseif e:GetLabel()==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()~=0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		Duel.ShuffleHand(tp)
	end
	end
end
