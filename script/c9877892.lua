--谣言鹤乃-异时间线

c9877892.Uwasa=true
function c9877892.initial_effect(c)
	aux.AddCodeList(c,9877877)
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9877892)
	e1:SetCondition(c9877892.spcon)
	e1:SetTarget(c9877892.sptg)
	e1:SetOperation(c9877892.spop)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877892,0))
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetCountLimit(1,1877892) 
	e11:SetTarget(c9877892.target)
	e11:SetOperation(c9877892.operation)
	c:RegisterEffect(e11)
end
function c9877892.f(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9877877)
end
function c9877892.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9877892.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9877892.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877892.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c9877892.tgfilter(c)
	return aux.IsCodeListed(c,9877877) and c:IsAbleToGrave()
end
function c9877892.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877892.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9877892.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9877892.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end