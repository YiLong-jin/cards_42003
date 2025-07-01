--神滨的小丘比
function c99900370.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x676),1,true)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99900370,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c99900370.indcon)
	e2:SetOperation(c99900370.indop)
	c:RegisterEffect(e2)
end
function c99900370.indcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 
		and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99900370.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900370,1))
end