--火力降临·瀑水手里剑
function c9879290.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879290,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9879290+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9879290.condition)
	e1:SetTarget(c9879290.destg)
	e1:SetOperation(c9879290.desop)
	c:RegisterEffect(e1)
end
function c9879290.filter(c)
	return c:IsSetCard(0x67a3) and c:IsFaceup()
end
function c9879290.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x67a3) and c:IsRace(RACE_AQUA)
end
function c9879290.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x67a3) and c:IsRace(RACE_FAIRY)
end
function c9879290.atkfilter(c)
	return c:IsFaceup()
end
function c9879290.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x67a3)
end
function c9879290.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0 and ct==Duel.GetMatchingGroupCount(c9879290.filter,tp,LOCATION_MZONE,0,nil)
end
function c9879290.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9879290.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.IsExistingMatchingCard(c9879290.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		   local g=Duel.GetMatchingGroup(c9879290.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
		if g:GetCount()>0  then 
			local sg=g:Select(tp,1,1,nil) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		end
	   end
	  if Duel.IsExistingMatchingCard(c9879290.filter3,tp,LOCATION_MZONE,0,1,nil) then
		local g2=Duel.GetMatchingGroup(c9879290.atkfilter,tp,LOCATION_MZONE,0,nil)
		 local bc=g2:GetFirst()
			while bc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(9879290,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(1000)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			bc:RegisterEffect(e3)
			bc=g2:GetNext()
		 end
	   end
	end
end