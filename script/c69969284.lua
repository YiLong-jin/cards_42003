--交响曲·木偶的步态舞
function c69969284.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x69b),2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969284,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,69969284)
	e1:SetTarget(c69969284.target)
	e1:SetOperation(c69969284.activate)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_SSET+TIMING_EQUIP+TIMING_END_PHASE)
	e5:SetCondition(c69969284.rmcon2)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969284,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,69969268)
	e2:SetCondition(c69969284.spcon2)
	e2:SetTarget(c69969284.sptg2)
	e2:SetOperation(c69969284.spop2)
	c:RegisterEffect(e2)
end
function c69969284.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4
end
function c69969284.filter(c,tp)
local g=c:GetEquipTarget()
	return c:IsFaceup() and bit.band(TYPE_MONSTER,c:GetOriginalType())~=0 and g
end
function c69969284.eqfilter(c,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return c:IsFaceup() 
end
function c69969284.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c69969284.filter(chkc,tp) end
	if chk==0 then
		return Duel.IsExistingTarget(c69969284.filter,tp,LOCATION_SZONE,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(c69969284.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c69969284.filter,tp,LOCATION_SZONE,0,1,1,nil,tp)
end
function c69969284.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local eq=tc:GetEquipTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.IsExistingMatchingCard(c69969284.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,eq) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c69969284.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,eq):GetFirst()
		Duel.DisableSelfDestroyCheck()
		if sc and Duel.Equip(tp,tc,sc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(sc)
			e1:SetValue(c69969284.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
	Duel.DisableSelfDestroyCheck(false)
end
function c69969284.eqlimit(e,c)
	return e:GetLabelObject()==c
end
--2
function c69969284.eqfilter3(c,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	return c:IsFaceup() 
end
function c69969284.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c69969284.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969284.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c69969284.eqfilter3,tp,LOCATION_MZONE,0,1,tc) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c69969284.eqfilter3,tp,LOCATION_MZONE,0,1,1,tc):GetFirst()
		if Duel.Equip(tp,tc,ec) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(ec)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		tc:RegisterEffect(e1)   
	end
end
end
