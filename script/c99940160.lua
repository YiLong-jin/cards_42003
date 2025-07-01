--神滨魔法少女 蓝家姬奈
function c99940160.initial_effect(c)
 --spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,99940160+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c99940160.spcon)
	c:RegisterEffect(e1)



  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c99940160.indcon)
	e3:SetOperation(c99940160.indop)
	c:RegisterEffect(e3)
end
function c99940160.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsType(TYPE_FUSION)
end
function c99940160.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and #g==Duel.GetMatchingGroupCount(c99940160.cfilter,tp,LOCATION_MZONE,0,1,nil)
end


function c99940160.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99940160.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_SWAP_BASE_AD)
	ex1:SetTargetRange(0,LOCATION_MZONE)
	ex1:SetTarget(function(e,c)
		return c:IsFaceup() and not c:IsImmuneToEffect(e)
	end)
	ex1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(ex1,true)  rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99940160,2))
	return ex1
end
