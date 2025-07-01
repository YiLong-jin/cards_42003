--交响曲·木星
function c69969210.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c69969210.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969210,0)) 
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,69969210)   
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetTarget(c69969210.eqtg)
	e1:SetOperation(c69969210.eqop)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(function(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(69969210,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,69969222)
	e2:SetCondition(c69969210.discon) 
	e2:SetTarget(c69969210.distg)
	e2:SetOperation(c69969210.disop)
	c:RegisterEffect(e2)
end
function c69969210.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x69b)
end
function c69969210.eqfil(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c69969210.eqtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c69969210.eqfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c69969210.eqfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c69969210.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
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
function c69969210.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end 
function c69969210.etgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0x69b) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0   
end 
function c69969210.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local xg=e:GetHandler():GetEquipGroup()
	if chk==0 then return xg and xg:IsExists(c69969210.etgfil,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c69969210.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local xg=e:GetHandler():GetEquipGroup()
	if xg and xg:IsExists(c69969210.etgfil,1,nil) then  
		local dg=xg:FilterSelect(tp,c69969210.etgfil,1,1,nil) 
		if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 then 
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		end 
	end 
end



