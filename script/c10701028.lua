--吸血鬼大臣
function c10701028.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701028,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10701028.setcon)
	e1:SetTarget(c10701028.settg)
	e1:SetOperation(c10701028.setop)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701028,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10701028)
	e2:SetCondition(c10701028.spcon)
	e2:SetTarget(c10701028.sptg)
	e2:SetOperation(c10701028.spop)
	c:RegisterEffect(e2)   
end
function c10701028.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(1-tp)
end
function c10701028.setcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(c10701028.cfilter,1,nil,tp)
end
function c10701028.setfilter(c,tp)
	return c:IsSSetable(true) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c10701028.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c10701028.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10701028.setfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c10701028.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
end
function c10701028.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		 if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then 
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		 elseif tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP) then
			Duel.SSet(tp,tc)
		 end
	end
end
function c10701028.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsRace(RACE_ZOMBIE)
end
function c10701028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701028.cfilter2,1,nil,tp)
end
function c10701028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end