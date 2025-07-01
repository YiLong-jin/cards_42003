--交响曲·魔王
function c69969214.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x69b),2)
	c:EnableReviveLimit()
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e) 
	return e:GetHandler():GetLinkedGroup():GetSum(Card.GetAttack) end)
	c:RegisterEffect(e1) 
	--eq 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969214,0)) 
	e2:SetCategory(CATEGORY_EQUIP) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,69969214) 
	e2:SetTarget(c69969214.eqtg) 
	e2:SetOperation(c69969214.eqop) 
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(69969214,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCountLimit(1,69969224)  
	e3:SetTarget(c69969214.setg) 
	e3:SetOperation(c69969214.seop) 
	c:RegisterEffect(e3) 
end
function c69969214.rlfil(c,e,tp) 
	return c:IsReleasable() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)  
end 
function c69969214.eqfil(c) 
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()  
end 
function c69969214.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969214.rlfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c69969214.eqfil,tp,LOCATION_GRAVE,0,1,nil) end   
	local g=Duel.SelectMatchingCard(tp,c69969214.rlfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.Release(g,REASON_COST) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end 
function c69969214.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(c69969214.eqfil,tp,LOCATION_GRAVE,0,1,nil) then 
		local tc=g:Select(tp,1,1,nil):GetFirst()  
		local ec=Duel.SelectMatchingCard(tp,c69969214.eqfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()  
		if Duel.Equip(tp,ec,tc) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		ec:RegisterEffect(e1)   
		end 
	end 
end 
function c69969214.setg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local ec=c:GetEquipTarget()
	if chk==0 then return ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,ec,1,0,0)
end 
function c69969214.seop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local ec=c:GetEquipTarget() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and ec then 
		if Duel.Equip(tp,ec,c) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			ec:RegisterEffect(e1)   
		end  
	end 
end 









