--升阶魔法 - 真名解放 境界之龙
function c4409659.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4409659,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,4409659)
	e1:SetTarget(c4409659.target)
	e1:SetOperation(c4409659.activate)
	c:RegisterEffect(e1) 
	--ov 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,1409659)  
	e2:SetTarget(c4409659.ovtg) 
	e2:SetOperation(c4409659.ovop) 
	c:RegisterEffect(e2)  
end 
function c4409659.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsRankBelow(5) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c4409659.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1) and c:IsSetCard(0xd77) 
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c4409659.filter2(c,e,tp,mc,rk)
	return c:IsSetCard(0xd77) and c:IsRank(7) and mc:IsCanBeXyzMaterial(c) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c4409659.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingTarget(c4409659.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c4409659.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4409659.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4409659.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
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
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end
end 
function c4409659.ovfil(c,e,re) 
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRankAbove(7)	and c:IsSetCard(0xd77) and c:IsCanBeEffectTarget(e) and re:GetHandler():IsSetCard(0x95)
end 
function c4409659.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return re and eg:IsExists(c4409659.ovfil,1,nil,e,re) end 
	local g=eg:FilterSelect(tp,c4409659.ovfil,1,1,nil,e,re) 
	Duel.SetTargetCard(g) 
end 
function c4409659.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then 
	Duel.Overlay(tc,c) 
	end 
end 





