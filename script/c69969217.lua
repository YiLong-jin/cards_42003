--交响曲·天鹅湖
function c69969217.initial_effect(c)
c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x69b),aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),true)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969217,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,69969217)
	e1:SetCondition(c69969217.descon)
	e1:SetTarget(c69969217.eqtg)
	e1:SetOperation(c69969217.eqop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969217,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetCountLimit(1,69969227)
	e2:SetCondition(c69969217.thcon)
	e2:SetTarget(c69969217.sptg2)
	e2:SetOperation(c69969217.spop2)
	c:RegisterEffect(e2)
end
function c69969217.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c69969217.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x69b) and not c:IsCode(69969217)
end
function c69969217.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c69969217.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c69969217.filter,tp,LOCATION_MZONE,0,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969218,0x69b,TYPES_TOKEN_MONSTER,2100,2600,8,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c69969217.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c69969217.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c69969217.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,69969218,0x69b,TYPES_TOKEN_MONSTER,2100,2600,8,RACE_FIEND,ATTRIBUTE_DARK) then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,69969218)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c69969217.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--2
function c69969217.thcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return ec and c:IsReason(REASON_LOST_TARGET)
		and not c:IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c69969217.confilter(c,e,tp)
	local ec=c:GetPreviousEquipTarget()
	return c:IsCode(ec:GetOriginalCode()) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69969217.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local race=ec:GetOriginalRace()
	local attr=ec:GetOriginalAttribute()
	local atk=ec:GetBaseAttack()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969219,0,TYPES_TOKEN_MONSTER,atk,0,4,race,attr) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,2) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	e:SetLabel(race,attr,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969217.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race,attr,atk=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69969219,0,TYPES_TOKEN_MONSTER,atk,0,4,race,attr) then
		local token=Duel.CreateToken(tp,69969219)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(attr)
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_ATTACK)
		e3:SetValue(atk)
		token:RegisterEffect(e3)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		if c:IsRelateToEffect(e) then 
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		end
	end
end

