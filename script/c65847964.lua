--异界 洛洛离
function c65847964.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65847964+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65847964.spcon)
	e1:SetOperation(c65847964.spop)
	c:RegisterEffect(e1)
end
function c65847964.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e6) and c:IsType(TYPE_LINK)
end
function c65847964.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65847964.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65847964.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(8)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
