--秋野枫
local s,id,o=GetID()
function c9877897.initial_effect(c)
	aux.AddCodeList(c,9877895,9877896,9877897)
	
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCountLimit(1,9877897)
	e1:SetCondition(c9877897.spcon)
	e1:SetTarget(c9877897.sptg)
	e1:SetOperation(c9877897.spop)
	c:RegisterEffect(e1)

end
function c9877897.f(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) )
end
function c9877897.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9877897.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9877897.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877897.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
