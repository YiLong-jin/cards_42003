--灾难等级SS-世界吞噬者
function c9877361.initial_effect(c) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),3)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c) 
	return e:GetHandler():GetLinkedGroup():IsContains(c) end)
	c:RegisterEffect(e1)
	--des and dam 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9877361)
	e2:SetCondition(c9877361.ddcon) 
	e2:SetTarget(c9877361.ddtg)  
	e2:SetOperation(c9877361.ddop) 
	c:RegisterEffect(e2) 
	--to grave and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,1877361)   
	e2:SetCondition(function(e)  
	local re=e:GetHandler():GetReasonEffect()
	return re and e:GetHandler():IsReason(REASON_EFFECT) end)
	e2:SetTarget(c9877361.tgdtg) 
	e2:SetOperation(c9877361.tgdop) 
	c:RegisterEffect(e2) 
end 
function c9877361.ddckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) 
end 
function c9877361.ddcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c9877361.ddckfil,1,nil,tp)  
end 
function c9877361.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x27e4) 
end 
function c9877361.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9877361.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function c9877361.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877361.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if x>0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877361,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end 
end 
function c9877361.tspfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x27e4) and c:IsLevelBelow(8) and c:IsFaceup() 
end 
function c9877361.tgdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877361.tspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c9877361.tgdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877361.tspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(9877361,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,TYPE_MONSTER) 
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end  
end 












