--交响曲·魔弹射手
function c69969236.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969236,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c69969236.spcost)
	e1:SetCountLimit(1,69969236)
	e1:SetTarget(c69969236.sptg)
	e1:SetOperation(c69969236.spop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969236,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,69969240)
	e2:SetCondition(c69969236.spcon2)
	e2:SetTarget(c69969236.sptg2)
	e2:SetOperation(c69969236.spop2)
	c:RegisterEffect(e2)
	end
function c69969236.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c69969236.cfilter(c)
	return c:IsSetCard(0x69b,0x108) and c:IsAbleToGraveAsCost()
end
function c69969236.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969236.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c69969236.cfilter,1,1,REASON_COST,e:GetHandler())
end
function c69969236.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969237,0x108,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969237,0x108,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
 Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c69969236.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,69969237,0x108,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969237,0x108,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,69969237)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,69969237)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
local c=e:GetHandler()
local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
if Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c69969236.filter,tp,0,LOCATION_MZONE,1,nil) then
	Duel.BreakEffect()
local tc=g:Select(tp,1,1,nil):GetFirst()  
 if Duel.Equip(tp,c,tc) then
local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		c:RegisterEffect(e1) 
end
end
end
end
--2
function c69969236.spcon2(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then return false end
		col=aux.SZoneSequence(seq)
	else
		return false
	end
	if p==1-tp then col=4-col end
	return aux.GetColumn(c,tp)==col and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and e:GetHandler():GetEquipTarget()
end
function c69969236.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969236.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and tc then
		Duel.BreakEffect()
		Duel.Equip(tp,tc,c,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c69969236.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c69969236.eqlimit(e,c)
	return e:GetOwner()==c
end