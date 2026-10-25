--小镇一隅的微光
function c9878241.initial_effect(c)
	aux.AddCodeList(c,9877896,9877905,9878241)
	c:SetUniqueOnField(1,0,9878241)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9878241+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)


	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9878241,0))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1)
	e12:SetTarget(c9878241.sptg)
	e12:SetOperation(c9878241.spop)
	c:RegisterEffect(e12)

end
function c9878241.filter(c)
	return c:IsAbleToDeck() and c:IsLevelAbove(8) and c:IsType(TYPE_MONSTER)
end
function c9878241.spfil(c,e,tp)
	return c:IsCode(9877905) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c9878241.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c9878241.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9878241.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9878241.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9878241.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
	 local g=Duel.SelectMatchingCard(tp,c9878241.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	 local xc=g:GetFirst()
		Duel.SpecialSummon(xc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		xc:CompleteProcedure()
	end
end