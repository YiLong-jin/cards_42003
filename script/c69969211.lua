--月华的协奏曲
function c69969211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--equip 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_EQUIP) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1)
	e2:SetTarget(c69969211.eqtg) 
	e2:SetOperation(c69969211.eqop) 
	c:RegisterEffect(e2) 
	--sp and eq 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCountLimit(2,69969211) 
	e3:SetCondition(c69969211.secon)
	e3:SetTarget(c69969211.setg) 
	e3:SetOperation(c69969211.seop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)   
	c:RegisterEffect(e4) 
end 
function c69969211.eqfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x69b) and c:GetEquipCount()==0  
end  
function c69969211.geqfil(c)
	return c:IsSetCard(0x69b) and c:IsLevelBelow(4) and not c:IsForbidden() 
end 
function c69969211.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c69969211.eqfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c69969211.geqfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	local g=Duel.SelectTarget(tp,c69969211.eqfil,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end 
function c69969211.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c69969211.geqfil,tp,LOCATION_GRAVE,0,nil)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then 
		local ec=g:Select(tp,1,1,nil):GetFirst() 
		if Duel.Equip(tp,ec,tc) then  
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			ec:RegisterEffect(e1)	
		end 
	end 
end 
function c69969211.secon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end 
function c69969211.espfil(c,e,tp) 
	local ec=c:GetEquipTarget()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x69b) and  ec  
end 
function c69969211.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c69969211.espfil,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c69969211.espfil,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_MZONE)
end 
function c69969211.seop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local ec=tc:GetEquipTarget() 
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and ec then 
		if Duel.Equip(tp,ec,tc) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			ec:RegisterEffect(e1)   
		end  
	end 
end 















