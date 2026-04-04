--春风的天马骑士-凯拉
function c9875670.initial_effect(c)
	aux.AddCodeList(c,9875671,9875669)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9875670) 
	e1:SetTarget(c9875670.sptg) 
	e1:SetOperation(c9875670.spop) 
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,9875670)
	e2:SetTarget(c9875670.thtg)
	e2:SetOperation(c9875670.thop)
	c:RegisterEffect(e2)
end 
function c9875670.ckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)   
end 
function c9875670.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875670.ckfil,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	local g=Duel.SelectTarget(tp,c9875670.ckfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c9875670.plfil(c) 
	return c:IsCode(9875671) and not c:IsForbidden()	
end 
function c9875670.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsCode(9875669) and tc:IsAbleToGrave() and tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c9875670.plfil,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875670,0)) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then 
		local sc=Duel.SelectMatchingCard(tp,c9875670.plfil,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	end 
end 



function c9875670.atkfilter(c)
	return c:IsSetCard(0x2ea7) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c9875670.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9875670.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9875670.thop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c9875670.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end