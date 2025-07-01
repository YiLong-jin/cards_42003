--驱动女神暴力破解
function c71100289.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
   e1:SetCountLimit(1,71100289+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71100289.target)
	e1:SetOperation(c71100289.activate)
	c:RegisterEffect(e1)
end
function c71100289.tfilter(c,att,e,tp,tc)
	return c:IsSetCard(0x17df) and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c71100289.filter(c,e,tp)
	return  c:IsSetCard(0x17df)
		and Duel.IsExistingMatchingCard(c71100289.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,c) and c:IsReleasableByEffect()
end
function c71100289.chkfilter(c,att)
	return c:IsFaceup() and c:IsSetCard(0x17df) and (c:GetAttribute()&att)==att 
end
function c71100289.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and(chkc:IsLocation(LOCATION_HAND) or chkc:IsLocation(LOCATION_MZONE) ) and c71100289.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c71100289.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) end
end
function c71100289.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c71100289.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local rg=g:GetFirst()
	local att=rg:GetAttribute()
	if Duel.Release(g,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c71100289.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,nil)
	if sg:GetCount()>0 then
		local rg2=sg:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				rg2:RegisterEffect(e1)
	end
end
end