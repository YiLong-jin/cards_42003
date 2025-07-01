--机械师 西格玛
function c9990390.initial_effect(c)
	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9990390+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9990390.sspcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9990391)
	e2:SetTarget(c9990390.efftg)
	e2:SetOperation(c9990390.effop)
	c:RegisterEffect(e2)
end
function c9990390.sspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
function c9990390.effspfilter(c,e,tp)
	return c:IsSetCard(0x671) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9990390.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9990390.effspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9990390.cfilter(c)
	return c:IsFaceup() and c:IsCode(9990320)
end
function c9990390.thfilter(c)
	return c:IsSetCard(0x671) and c:IsAbleToHand()
end
function c9990390.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990390.effspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c9990390.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local h=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9990390.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(h,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,h)
	end
end
function c9990390.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x671) and c:IsLocation(LOCATION_EXTRA)
end