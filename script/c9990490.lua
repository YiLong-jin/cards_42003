--逆位卡巴拉因子 龙血
function c9990490.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9990490.target)
	e1:SetOperation(c9990490.activate)
	c:RegisterEffect(e1)
end
function c9990490.counterfilter(c)
	return c:IsSetCard(0x671)
end
function c9990490.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and c:IsSetCard(0x671)
		and Duel.IsExistingMatchingCard(c9990490.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9990490.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_LINK) and c:IsCode(9990220)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9990490.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990490.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,3,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990490.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c9990490.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,3,3,c,e,tp)
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c9990490.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end