--恐惧的震慑
function c9877367.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9877367+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9877367.condition)
	e1:SetTarget(c9877367.target)
	e1:SetOperation(c9877367.activate)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCondition(c9877367.setcon) 
	e2:SetTarget(c9877367.settg)  
	e2:SetOperation(c9877367.setop) 
	c:RegisterEffect(e2) 
end
function c9877367.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27e4) 
end
function c9877367.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c9877367.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9877367.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9877367.spfil(c,e,tp) 
	return c:IsSetCard(0x27e4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c9877367.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local x=Duel.Destroy(eg,REASON_EFFECT)
		if x>0 and Duel.IsExistingMatchingCard(c9877367.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9877367,0)) then 
			Duel.BreakEffect() 
			local sg=Duel.SelectMatchingCard(tp,c9877367.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)   
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
		end 
	end
end
function c9877367.ddckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) 
end 
function c9877367.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c9877367.ddckfil,1,nil,tp)  
end 
function c9877367.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9877367.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end






