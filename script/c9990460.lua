--特拉德赛之釜
function c9990460.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9990460.rktg)
	e1:SetOperation(c9990460.rkop)
	c:RegisterEffect(e1)
end
function c9990460.counterfilter(c)
	return c:IsSetCard(0x671)
end
function c9990460.costfilter1(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9990460.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990460.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9990460.costfilter1,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9990460.rkfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x674)
		and Duel.IsExistingTarget(c9990460.lvfilter,tp,LOCATION_MZONE,0,1,c,c:GetRank())
end
function c9990460.lvfilter(c,rk)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x671) and not c:IsRank(rk)
end
function c9990460.rktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9990460.rkfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9990460.rkfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9990460.lvfilter,tp,LOCATION_MZONE,0,1,1,g:GetFirst(),g:GetFirst():GetRank())
end
function c9990460.rkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and lc:IsRelateToEffect(e) and lc:IsFaceup() and lc:IsSetCard(0x671) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RANK)
		e1:SetValue(lc:GetRank())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9990460.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9990460,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9990460.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end