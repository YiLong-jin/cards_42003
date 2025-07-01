--交响曲·唐豪瑟
function c69969273.initial_effect(c)
c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c69969273.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969273,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c69969273.spcon)
	e1:SetTarget(c69969273.sptg1)
	e1:SetOperation(c69969273.spop1)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c69969273.reptg)
	e2:SetOperation(c69969273.repop)
	e2:SetValue(c69969273.repval)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969273,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c69969273.spcost)
	e3:SetTarget(c69969273.sptg)
	e3:SetOperation(c69969273.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c69969273.val)
	c:RegisterEffect(e4)
end
function c69969273.val(e,c)
	return c:GetEquipCount()*1000
end
function c69969273.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x69b)
end
function c69969273.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c69969273.eqfilter(c,tp)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp)
end
function c69969273.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c69969273.eqfilter(chkc,tp) and chkc:IsControler(tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0
		and Duel.IsExistingTarget(c69969273.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
		end
	if ft>3 then ft=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectTarget(tp,c69969273.eqfilter,tp,LOCATION_GRAVE,0,1,ft,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,#sg,0,0)
end
function c69969273.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return end
		if g:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g=g:Select(tp,ft,ft,nil)
		end
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.Equip(tp,tc,c,true,true)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c69969273.eqlimit)
				tc:RegisterEffect(e1)
				tc=g:GetNext()
			end
			Duel.EquipComplete()
		end
	end
function c69969273.eqlimit(e,c)
	return e:GetOwner()==c
end
--2
function c69969273.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x69b) and c:IsControler(tp) and c:IsOnField() 
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c69969273.dfilter(c,e)
	return c:GetEquipTarget() and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c69969273.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c69969273.dfilter,tp,LOCATION_SZONE,0,nil,e)
	if chk==0 then return eg:IsExists(c69969273.filter,1,nil,tp)
		and #g>0 end
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SetTargetCard(tc)
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c69969273.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c69969273.repval(e,c)
	return c69969273.filter(c,e:GetHandlerPlayer())
end
--3
function c69969273.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function c69969273.spfilter(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x69b) and not c:IsCode(69969273) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c69969273.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c69969273.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c69969273.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c69969273.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end