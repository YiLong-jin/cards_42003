--晶龙之阵
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	c:RegisterEffect(e3)
end
--e2
function cm.val2(e,c)
	local atk=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):Filter(Card.IsSetCard,nil,0x6661):GetClassCount(Card.GetAttribute)
	return atk*200
end
--e3
function cm.conf3(c,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsSummonPlayer(tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.conf3,1,nil,tp)
end
function cm.tgf1(c,g)
	if not g:IsExists(Card.IsAttribute,1,nil,c:GetAttribute()) then return false end
	if c:IsLocation(LOCATION_DECK) then return c:IsAbleToHand() end
	return c:IsDiscardable(REASON_EFFECT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local v=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_DECK+LOCATION_HAND,0,nil,eg:Filter(cm.conf3,nil,tp))
	local b1=v:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0
	local b2=v:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return b1 or b2 end
	v={b1 and 1190 or aux.Stringid(m,0),b1 and b2 and aux.Stringid(m,0) or nil}
	v=Duel.SelectOption(tp,table.unpack(v))+(not b1 and b2 and 1 or 0)
	e:SetLabel(v)
	if v==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetOperation(cm.op31)
	else
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		e:SetOperation(cm.op32)
	end
end
function cm.op31(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil,eg:Filter(cm.conf3,nil,tp))
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.op32(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_HAND,0,nil,eg:Filter(cm.conf3,nil,tp))
	if Duel.SendtoGrave(g:Select(tp,1,1,nil),REASON_EFFECT+REASON_DISCARD)==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end