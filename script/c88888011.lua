--破碎灵魂的枪击
function c88888011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88888011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88888011.target)
	e1:SetOperation(c88888011.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,18888011)
	e2:SetCondition(c88888011.matcon)
	e2:SetTarget(c88888011.mattg)
	e2:SetOperation(c88888011.matop)
	c:RegisterEffect(e2)
	--re
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888011,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c88888011.tdcon)
	e3:SetCost(c88888011.tdcost)
	e3:SetTarget(c88888011.tdtg)
	e3:SetOperation(c88888011.tdop)
	c:RegisterEffect(e3)
end
function c88888011.tfilter(c)
	return c:IsSetCard(0x8980) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88888011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888011.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88888011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88888011.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88888011.cfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x8980) and c:IsCanBeEffectTarget(e)
end
function c88888011.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88888011.cfilter,1,nil,e)
end
function c88888011.tgfilter(c,eg)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c88888011.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c88888011.tgfilter(chkc,eg) end
	if chk==0 then return Duel.IsExistingTarget(c88888011.tgfilter,tp,LOCATION_MZONE,0,1,nil,eg)
		and e:GetHandler():IsCanOverlay() end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c88888011.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c88888011.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c88888011.tdfilter(c)
	return c:IsSetCard(0x8980) and c:IsAbleToDeck()
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c88888011.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x8980)
end
function c88888011.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c88888011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c88888011.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c88888011.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88888011.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g>0 then
		local tg=g:Select(tp,1,5,nil)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end