--交响曲·卡农
function c69969215.initial_effect(c)
	c:EnableCounterPermit(0x69a,LOCATION_PZONE+LOCATION_MZONE) 
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c69969215.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetRange(LOCATION_MZONE+LOCATION_PZONE) 
	e1:SetCondition(c69969215.adcon) 
	e1:SetOperation(c69969215.adop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--p set 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(69969215,1))
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,69969215) 
	e3:SetCost(c69969215.psetcost)
	e3:SetTarget(c69969215.psettg) 
	e3:SetOperation(c69969215.psetop) 
	c:RegisterEffect(e3)
	--sp and link
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(69969215,2)) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,69969225) 
	e4:SetCost(c69969215.splcost)
	e4:SetTarget(c69969215.spltg) 
	e4:SetOperation(c69969215.splop) 
	c:RegisterEffect(e4)
	--dis sp eq 
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(69969215,3))
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP) 
	e5:SetType(EFFECT_TYPE_QUICK_O) 
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET) 
	e5:SetRange(LOCATION_PZONE) 
	e5:SetCountLimit(1,69969226)  
	e5:SetCondition(c69969215.dsecon)
	e5:SetCost(c69969215.dsecost)
	e5:SetTarget(c69969215.dsetg) 
	e5:SetOperation(c69969215.dseop) 
	c:RegisterEffect(e5) 
end
function c69969215.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x69b)
end 
function c69969215.adcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsCanAddCounter(0x69a,1)  
end 
function c69969215.adop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if e:GetHandler():IsCanAddCounter(0x69a,1) then 
		c:AddCounter(0x69a,1) 
	end 
end 
function c69969215.psetcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x69a,3,REASON_COST) end 
	e:GetHandler():RemoveCounter(tp,0x69a,3,REASON_COST) 
end 
function c69969215.psettg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end 
end 
function c69969215.psetop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then 
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end 
end 
function c69969215.splcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x69a,5,REASON_COST) end 
	e:GetHandler():RemoveCounter(tp,0x69a,5,REASON_COST) 
end 
function c69969215.espfil(c,e,tp,mg)  
	return c:IsType(TYPE_LINK) and c:IsLinkSummonable(mg) 
end 
function c69969215.spfil(c,e,tp) 
	local mg=Group.FromCards(c,e:GetHandler())
	return e:GetHandler():GetEquipGroup():IsContains(c) and Duel.IsExistingMatchingCard(c69969215.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) 
end 
function c69969215.spltg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c69969215.spfil,tp,LOCATION_SZONE,0,1,nil,e,tp) end  
	local g=Duel.SelectTarget(tp,c69969215.spfil,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c69969215.splop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local mg=Group.FromCards(c,tc) 
		if Duel.IsExistingMatchingCard(c69969215.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) then 
			local sc=Duel.SelectMatchingCard(tp,c69969215.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
			Duel.LinkSummon(tp,sc,mg) 
		end   
	end 
end  
function c69969215.dsecon(e,tp,eg,ep,ev,re,r,rp)  
	local ct=Duel.GetCurrentChain()
	if ct<2 then return false end 
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x69b) and p==tp and rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end  
function c69969215.dsecost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x69a,4,REASON_COST) end 
	e:GetHandler():RemoveCounter(tp,0x69a,4,REASON_COST) 
end 
function c69969215.deqfil(c) 
	return not c:IsForbidden()  
end 
function c69969215.dsetg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c69969215.deqfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c69969215.deqfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end 
function c69969215.dseop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then 
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		tc:RegisterEffect(e1)
	end 
end 











