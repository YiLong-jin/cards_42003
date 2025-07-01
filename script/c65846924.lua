--反魂蝶-八分咲
function c65846924.initial_effect(c)
	aux.AddCodeList(c,65846916)
	local e1=Effect.CreateEffect(c)----{发动效果}
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846924+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65846924.spcost)
	e1:SetOperation(c65846924.spop)
	c:RegisterEffect(e1)	
end
function c65846924.costfilter(c)
	return c:IsRace(0x10) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
end
function c65846924.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65846924.costfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65846924.costfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		e:SetCategory(CATEGORY_DRAW)
		e:SetLabel(1)
	elseif tc:IsLocation(LOCATION_MZONE) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(2)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetLabel(3)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65846924.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
	local cl=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	if cl==1 then
		e1:SetCondition(c65846924.drcon)
		e1:SetOperation(c65846924.drop)
	elseif cl==2 then
		e1:SetCondition(c65846924.spcon2)
		e1:SetOperation(c65846924.spop2)
	else
		e1:SetCondition(c65846924.tgcon)
		e1:SetOperation(c65846924.tgop)
	end
	e1:SetLabel(Duel.GetTurnCount()+1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
	Duel.RegisterEffect(e1,tp)
end
function c65846924.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(c,65846916) and c:IsFaceupEx()
end
function c65846924.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846924.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetTurnCount()==e:GetLabel()
end
function c65846924.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65846924)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846924.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65846924.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp,1) and Duel.GetTurnCount()==e:GetLabel()
end
function c65846924.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65846924)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c65846924.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetTurnCount()==e:GetLabel()
end
function c65846924.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65846924)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
end