--大晶龙 彩羽虹龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.F,4,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff)
	e1:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6661))
	e5:SetValue(cm.val5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(cm.tg6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
end
function cm.F(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x6661) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
--e5
function cm.val5(e,c)
	return Duel.GetMatchingGroup(Card.IsSetCard,0,LOCATION_GRAVE,0,nil,0x6661):GetClassCount(Card.GetAttribute)*200
end
--e6
function cm.tgf6(c)
	return c:IsSetCard(0x6661) and c:IsFaceup()
end
function cm.tg6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.tgf6(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf6,tp,LOCATION_REMOVED,0,2,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74586817,2))
	local g=Duel.SelectTarget(tp,cm.tgf6,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end