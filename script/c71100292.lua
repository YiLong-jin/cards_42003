--heidisi
function c71100292.initial_effect(c)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c71100292.splimit)
	c:RegisterEffect(e0)
	--revive
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100292,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,71100292)
	e1:SetCondition(c71100292.rvcon)
	e1:SetTarget(c71100292.rvtg)
	e1:SetOperation(c71100292.rvop)
	c:RegisterEffect(e1)
   --send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100292,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71101292)
	e2:SetCondition(c71100292.thcon)
	e2:SetTarget(c71100292.thtg)
	e2:SetOperation(c71100292.thop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c71100292.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x7d1)
end
function c71100292.cfilter(c)
	return  c:IsSetCard(0x7d0) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c71100292.rvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71100292.cfilter,1,nil)
end
function c71100292.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100292.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100292.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7d1)
end
function c71100292.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71100292.cfilter2,1,nil)
end
function c71100292.tgfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c71100292.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c71100292.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c71100292.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71100292.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end