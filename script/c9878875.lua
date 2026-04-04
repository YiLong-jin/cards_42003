--银月鬼杀者-狮子凌芽
function c9878875.initial_effect(c)
	aux.AddCodeList(c,9877864) 

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9878875.efilter)
	c:RegisterEffect(e1)

	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,9878875)
	e0:SetCondition(c9878875.spcon)
	e0:SetTarget(c9878875.sptg)
	e0:SetOperation(c9878875.spop)
	c:RegisterEffect(e0)
	
end
function c9878875.efilter(e,te)
	return not te:GetOwner():IsCode(9877866)
end

function c9878875.consfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and aux.IsCodeListed(c,9877864)
end

function c9878875.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9878875.consfilter,tp,0x04,0,1,nil)
end

function c9878875.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c9878875.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end