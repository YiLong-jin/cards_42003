--七尾
function c9879047.initial_effect(c)
	aux.AddCodeList(c,9879042)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)


	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e02:SetCountLimit(1,9879047)
	e02:SetCondition(c9879047.spcon)
	e02:SetTarget(c9879047.sptg)
	e02:SetOperation(c9879047.spop)
	c:RegisterEffect(e02)  
end
function c9879047.f(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9879042)
end
function c9879047.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9879047.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9879047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879047.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end