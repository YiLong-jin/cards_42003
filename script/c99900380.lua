--神滨的谣 万年樱
function c99900380.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c99900380.ffilter,2,true)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99900380,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c99900380.indcon)
	e2:SetOperation(c99900380.indop)
	c:RegisterEffect(e2)
end
function c99900380.ffilter(c,fc)
	return c:IsFusionSetCard(0x676) 
end
function c99900380.indcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 
		and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99900380.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c99900380.attval)
	rc:RegisterEffect(e1)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900380,0))
end
function c99900380.attval(e,c)
	local c=e:GetHandler()
	local og=c:GetMaterial()
	local wbc=og:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=og:GetNext()
	end
	return att
end