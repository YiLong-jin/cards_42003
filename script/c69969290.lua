--交响曲·睡美人
function c69969290.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c69969290.mfilter,2,2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969290,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,c69969290)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c69969290.spcon)
	e3:SetTarget(c69969290.sptg)
	e3:SetOperation(c69969290.spop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c69969290.reccon)
	e1:SetOperation(c69969290.recop)
	c:RegisterEffect(e1)
end
function c69969290.mfilter(c,fc)
	return (c:IsOnField() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and c:IsControler(fc:GetControler())
end
--1
function c69969290.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c69969290.ffilter(c,e,tp)
	return c:IsSetCard(0x69b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsType(TYPE_MONSTER)
end
function c69969290.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c69969290.ffilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c69969290.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133)
		or Duel.GetMatchingGroupCount(c69969290.ffilter,tp,LOCATION_GRAVE,0,nil,e,tp)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c69969290.ffilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	local tc=sg:GetFirst()
		while tc do
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
end
--2
function c69969290.reccon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c69969290.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,69969290)
	Duel.Recover(tp,300,REASON_EFFECT)
end


