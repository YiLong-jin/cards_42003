--灾难等级A-破灭巨兽
function c9877355.initial_effect(c)
	--des and sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877355) 
	e1:SetTarget(c9877355.desptg) 
	e1:SetOperation(c9877355.despop) 
	c:RegisterEffect(e1) 
	--des and dam 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1877355)
	e2:SetCondition(c9877355.ddcon) 
	e2:SetTarget(c9877355.ddtg)  
	e2:SetOperation(c9877355.ddop) 
	c:RegisterEffect(e2) 
end 
function c9877355.desfil(c,e,tp) 
	return Duel.GetMZoneCount(tp,c)>0  
end 
function c9877355.desptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9877355.desfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	local g=Duel.SelectTarget(tp,c9877355.desfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c9877355.despop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)	
	end 
end 
function c9877355.ddckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) 
end 
function c9877355.ddcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c9877355.ddckfil,1,nil,tp)  
end 
function c9877355.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500) 
end  
function c9877355.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then  
		local dg=g:Select(tp,1,1,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then 
			Duel.Damage(1-tp,500,REASON_EFFECT)  
		end 
	end 
end 
















