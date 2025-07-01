--童谣 侍从
function c65846978.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65846978+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c65846978.sprcon)
	e1:SetTarget(c65846978.sprtg)
	e1:SetOperation(c65846978.sprop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65846979)
	e2:SetCondition(c65846978.discon)
	e2:SetCost(c65846978.discost)
	e2:SetTarget(c65846978.distg)
	e2:SetOperation(c65846978.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c65846978.splimit)
	--c:RegisterEffect(e3)--[[③：只要这张卡在怪兽区域存在，自己不能从额外卡组把怪兽特殊召唤。]]
end
function c65846978.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c65846978.cfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsType(TYPE_CONTINUOUS) and Duel.GetMZoneCount(tp,c)>0
end
function c65846978.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c65846978.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp)
end
function c65846978.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c65846978.cfilter,tp,LOCATION_ONFIELD,0,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c65846978.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function c65846978.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c65846978.discfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()==c:GetBaseDefense() and c:IsLevel(7,8) and c:IsAbleToGraveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65846978.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65846978.discfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846978.discfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65846978.thfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()==c:GetBaseDefense() and c:IsLevel(7,8) and c:IsAbleToHand()
end
function c65846978.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846978.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846978.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c65846978.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c65846978.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.NegateEffect(ev)
	end
end