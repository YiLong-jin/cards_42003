--逐火之蛾的战士 希儿芙乐艾
function c9999960.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9999960)
	e1:SetCondition(c9999960.spcon)   
	e1:SetTarget(c9999960.sptg)
	e1:SetOperation(c9999960.spop)
	c:RegisterEffect(e1)
end
function c9999960.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x669) and c:IsType(TYPE_MONSTER) and not c:IsCode(9999960)
end
function c9999960.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9999960.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  
end
function c9999960.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9999960.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or   not c:IsRelateToEffect(e)  then return end
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end