--升阶魔法 被赝品继承的温柔
function c9990610.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9990610+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9990610.target)
	e1:SetOperation(c9990610.activate)
	c:RegisterEffect(e1)
end
--
function c9990610.counterfilter(c)
	return c:IsSetCard(0x671)
end
function c9990610.filter1(c,e,tp)
	local rk=0
	if c:IsLevelAbove(1) then
		rk=c:GetLevel()
	elseif c:IsRankAbove(1) then
		rk=c:GetRank()
	end
	return c:IsFaceup() and not c:IsType(TYPE_LINK) and rk>0
		and Duel.IsExistingMatchingCard(c9990610.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsSetCard(0x672)
end
function c9990610.filter2(c,e,tp,mc,rk)
	return c:IsType(TYPE_XYZ) and c:IsRank(rk) and c:IsSetCard(0x672) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9990610.filter3(c,e,tp,sc,rk)
	return c:IsType(TYPE_XYZ) and c:IsRank(rk) and c:IsSetCard(0x671) and sc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function c9990610.filter4(c)
	return c:IsReleasable() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x671) and not c:IsType(TYPE_XYZ)
end
function c9990610.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990610.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9990610.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9990610.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990610.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local rk=0
	if tc:IsLevelAbove(1) then
		rk=tc:GetLevel()
	elseif tc:IsRankAbove(1) then
		rk=tc:GetRank()
	end
	if rk==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990610.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,rk)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.IsExistingMatchingCard(c9990610.filter3,tp,LOCATION_EXTRA,0,1,sc,e,tp,tc,rk) and Duel.IsExistingMatchingCard(c9990610.filter4,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9990610,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g2=Duel.SelectMatchingCard(tp,c9990610.filter4,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,sc)
			if g2:GetCount()>0 then
				Duel.Release(g2,REASON_EFFECT)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=Duel.SelectMatchingCard(tp,c9990610.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc,rk)
			local sc2=g3:GetFirst()
			if sc2 then
				local mg2=sc:GetOverlayGroup()
				if mg2:GetCount()~=0 then
					Duel.Overlay(sc2,mg2)
				end
				sc2:SetMaterial(Group.FromCards(sc))
				Duel.Overlay(sc2,Group.FromCards(sc))
				Duel.SpecialSummon(sc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc2:CompleteProcedure()
			end
		end
	end
end
