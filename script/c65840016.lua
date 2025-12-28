--大阿卡那 高塔的随心者
function c65840016.initial_effect(c)
	aux.AddCodeList(c,65842060)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65840016,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c65840016.sptg)
	e2:SetOperation(c65840016.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP)
	c:RegisterEffect(e4)	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65840016,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCountLimit(1,65840016)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c65840016.setcon)
	e5:SetTarget(c65840016.settg)
	e5:SetOperation(c65840016.setop)
	c:RegisterEffect(e5)
end
function c65840016.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c65840016.spfilter(c,e,tp)
	return c:IsCode(65842060) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65840016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65840016.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,65840016)==0 end
	Duel.RegisterFlagEffect(tp,65840016,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c65840016.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65840016.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65840016.setfilter(c)
	return aux.IsCodeListed(c,65842060) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsFaceupEx()
end
function c65840016.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65840016.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c65840016.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65840016.setfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end