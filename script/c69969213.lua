--交响曲·幻想即兴曲
function c69969213.initial_effect(c)
	c:SetSPSummonOnce(69969213)
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x69b),4,2)
	c:EnableReviveLimit()   
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCost(c69969213.rescost)
	e1:SetTarget(c69969213.restg) 
	e1:SetOperation(c69969213.resop) 
	c:RegisterEffect(e1) 
	--des 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969213,0)) 
	e2:SetCategory(CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetTarget(c69969213.destg) 
	e2:SetOperation(c69969213.desop) 
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(69969213,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCondition(c69969213.secon)
	e3:SetTarget(c69969213.setg) 
	e3:SetOperation(c69969213.seop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e4) 
end
function c69969213.rescost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetOverlayCount()
	if chk==0 then return x>0 and e:GetHandler():CheckRemoveOverlayCard(tp,x,REASON_COST) end
	e:SetLabel(e:GetHandler():RemoveOverlayCard(tp,x,x,REASON_COST)) 
end
function c69969213.restg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(e:GetLabel()*800)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel()*800) 
end 
function c69969213.resop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsRelateToEffect(e) then 
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end 
end 
function c69969213.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c69969213.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) and tc:IsCanOverlay() then 
		Duel.Overlay(c,tc) 
	end 
end 
function c69969213.secon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end 
function c69969213.seqfil(c) 
	return not c:IsForbidden()   
end 
function c69969213.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c69969213.seqfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c69969213.seqfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end 
function c69969213.seop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then 
		if Duel.Equip(tp,tc,c) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		tc:RegisterEffect(e1)   
		end 
	end 
end  





