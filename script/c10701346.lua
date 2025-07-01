--火花待放的铸剑匠
function c10701346.initial_effect(c)
	aux.EnableDualAttribute(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701346,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10701346)
	e1:SetCost(c10701346.sumcost)
	e1:SetTarget(c10701346.sumtg)
	e1:SetOperation(c10701346.sumop)
	c:RegisterEffect(e1)	
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701346,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10701346.dlcon)
	e2:SetOperation(c10701346.dlop)
	c:RegisterEffect(e2)
	--to grave/search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701346,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10701347)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.IsDualState)
	e3:SetTarget(c10701346.tgtg1)
	e3:SetOperation(c10701346.tgop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701346,3))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,10701347)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.IsDualState)
	e4:SetTarget(c10701346.tgtg2)
	e4:SetOperation(c10701346.tgop2)
	c:RegisterEffect(e4)
end
function c10701346.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c10701346.sumfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsSummonable(true,nil)
end
function c10701346.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701346.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10701346.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701346.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c10701346.dlcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and not e:GetHandler():IsDualState()
end
function c10701346.dlop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_STATUS)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c10701346.filter1(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c10701346.thfilter1,tp,LOCATION_DECK,0,1,c)
end
function c10701346.tgfilter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
end
function c10701346.thfilter1(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function c10701346.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701346.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701346.tgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701346.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local sg=Duel.GetMatchingGroup(c10701346.thfilter1,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function c10701346.filter2(c,tp)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c10701346.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c10701346.tgfilter2(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave()
end
function c10701346.thfilter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c10701346.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701346.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701346.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701346.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local sg=Duel.GetMatchingGroup(c10701346.thfilter2,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end