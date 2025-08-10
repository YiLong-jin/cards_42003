--纳垢喷病巨蛆
function c21400090.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,function(c) return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) end,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT+RACE_FIEND),1,1,true)
	--Negate Activation
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE,CATEGORY_DESTROY+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c21400090.negcon)
	e1:SetTarget(c21400090.negtg)
	e1:SetOperation(c21400090.negop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21400090)
	e2:SetCondition(c21400090.spcon)
	e2:SetCost(c21400090.spcost)
	e2:SetTarget(c21400090.sptg)
	e2:SetOperation(c21400090.spop)
	c:RegisterEffect(e2)
end
function c21400090.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c21400090.negcfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1077)>0 and c:IsReleasableByEffect()
end
function c21400090.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400090.negcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c21400090.negcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c21400090.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21400090.negcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 and Duel.Release(g,REASON_EFFECT)~=0 and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end 
end
function c21400090.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c21400090.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1077,7,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1077,7,REASON_COST) 
end
function c21400090.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400090.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end




