--星变偶像·芙蕾德莉卡
function c9879053.initial_effect(c)
	 c:EnableCounterPermit(0x7e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e2:SetValue(1)
	c:RegisterEffect(e2)


	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(9879053,3))
	e17:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_HAND)
	e17:SetCountLimit(1,9879053)
	e17:SetCondition(c9879053.spcon)
	e17:SetTarget(c9879053.sptg)
	e17:SetOperation(c9879053.spop)
	c:RegisterEffect(e17) 
end
function c9879053.cfilter(c)
	return c:IsFaceup() and c:IsCanHaveCounter(0x7e2)
end
function c9879053.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879053.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9879053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879053.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 