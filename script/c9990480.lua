--逆位卡巴拉因子 芬里尔
function c9990480.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c9990480.target)
	e1:SetOperation(c9990480.activate)
	c:RegisterEffect(e1)
end
function c9990480.counterfilter(c)
	return c:IsSetCard(0x671)
end
function c9990480.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x671)
		and Duel.IsExistingMatchingCard(c9990480.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9990480.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsCode(9990200) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9990480.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990480.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9990480.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9990480.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990480.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990480.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
	end
	local mt=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9990480.mtfilter),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,sc,e)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 and #mt>0 and Duel.SelectYesNo(tp,aux.Stringid(9990480,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local xg=mt:Select(tp,1,1,nil)
			local tc1=xg:GetFirst()
			while tc1 do
				tc1:CancelToGrave()
				local og=tc1:GetOverlayGroup()
				if #og>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc1=xg:GetNext()
			end
			Duel.Overlay(sc,xg)
		end
		sc:CompleteProcedure()
end
function c9990480.mtfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e) and c:IsCode(9990370)
end