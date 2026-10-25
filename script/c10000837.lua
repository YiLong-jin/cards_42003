local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(10000813)
end
function s.spfilter(c,e,tp)
	return c:IsCode(10000813) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	local owner=tc:GetOwner()
	if Duel.SendtoDeck(tc,owner,0,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	if not Duel.IsExistingMatchingCard(s.spfilter,owner,LOCATION_EXTRA,0,1,nil,e,owner) then return end
	Duel.Hint(HINT_SELECTMSG,owner,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(owner,s.spfilter,owner,LOCATION_EXTRA,0,1,1,nil,e,owner)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(nil)
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,owner,owner,false,false,POS_FACEUP,0x60)
	end
end
