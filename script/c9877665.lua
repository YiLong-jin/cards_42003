--黑骑士小队-升腾
function c9877665.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c9877665.cost)
	e1:SetTarget(c9877665.target)
	e1:SetOperation(c9877665.activate)
	c:RegisterEffect(e1)

end
function c9877665.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000)
	else Duel.PayLPCost(tp,3000) end
end
function c9877665.filter1(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c9877665.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9877665.filter2(c,e,tp,mc)
	return c:IsRank(10) and c:IsSetCard(0x17ec) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9877665.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end 
function c9877665.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9877665.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9877665.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9877665.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9877665.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() 
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9877665.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
	   if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
			local g2=Duel.GetMatchingGroup(c9877665.tgfil1,tp,LOCATION_GRAVE,0,nil)
			if g2:GetCount()>0 and Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(9877665,0)) then
			Duel.PayLPCost(tp,1000)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
	sc:CompleteProcedure()
end


