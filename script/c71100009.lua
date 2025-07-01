--电子人2型
local cm,m,offset=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.sprcon)
	c:RegisterEffect(e1)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsLevel(4)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end