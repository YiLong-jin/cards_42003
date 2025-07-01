--神滨圣女之谣 阿莉娜
function c99940140.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND),aux.FilterBoolFunction(Card.IsFusionSetCard,0x676),2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)


	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99940140.thcon)
	e1:SetTarget(c99940140.tg)
	e1:SetOperation(c99940140.op)
	c:RegisterEffect(e1)

--  local e2=Effect.CreateEffect(c)
--  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
--  e2:SetCode(EVENT_BE_MATERIAL)
--  e2:SetCondition(c99940140.indcon)
--  e2:SetOperation(c99940140.indop)
--  c:RegisterEffect(e2)






end
function c99940140.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99940140.filter(c,e,tp)
	return c:IsSetCard(0x676)
end
function c99940140.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c99940140.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99940140.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99940140.filter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:Select(tp,2,2,nil)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
end



function c99940140.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99940140.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ex1:SetTargetRange(0xff,0xff)
	ex1:SetValue(LOCATION_DECK)
	ex1:SetTarget(function(e,c)
		return c:GetOwner()~=e:GetHandlerPlayer()
	end)
	ex1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(ex1,true)
	local ex2=ex1:Clone()
	ex2:SetCode(EFFECT_CANNOT_TO_GRAVE)
	ex2:SetTargetRange(0,LOCATION_DECK+LOCATION_EXTRA)
	ex2:SetTarget(function(e,c)
		return c:GetOwner()~=e:GetHandlerPlayer() and (c:IsLocation(LOCATION_DECK)
			or (c:IsLocation(LOCATION_EXTRA) and (c:GetOriginalType() & TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)~=0))
	end)
	ex2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(ex2,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99940140,2))
	return ex1,ex2
end









