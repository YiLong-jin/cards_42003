--暗黑晶龙 冥晶龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,99920000,cm.F,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
--m
function cm.F(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x6661) and c:IsAttribute(ATTRIBUTE_DARK)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.tgf1(e,ep,tp)
	return tp==ep
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(cm.tgf1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g=g:Select(tp,1,1,nil):GetFirst()
	local chk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):Filter(Card.IsSetCard,nil,0x6661):IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
	Duel.Remove(g,chk and POS_FACEDOWN or POS_FACEUP,REASON_EFFECT)
end