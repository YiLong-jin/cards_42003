--PSY骨架扫描
local m=30002030
local cm=_G["c"..m]
function c30002030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c30002030.target)
	e1:SetOperation(c30002030.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c30002030.handcon)
	c:RegisterEffect(e3)
end
function c30002030.handcon(e)
	return Duel.IsExistingMatchingCard(c30002030.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c30002030.tdfilter(c)
	return c:IsSetCard(0xc1) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c30002030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c30002030.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c30002030.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c30002030.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c30002030.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(30002030,2)) then
		Duel.BreakEffect()
		local c=e:GetHandler()
		local off=1
		local ops={}
		local opval={}
		if cm.sefilter(e) then
			ops[off]=aux.Stringid(m,0)
			opval[off-1]=1
			off=off+1
		end
		if cm.darwfilter(e) then
			ops[off]=aux.Stringid(m,1)
			opval[off-1]=2
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.sethfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		elseif opval[op]==2 then
			local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg=g:Select(tp,1,g:GetCount(),nil)
			local n=Duel.SendtoGrave(dg,REASON_EFFECT)
			Duel.Draw(tp,n,REASON_EFFECT)
		end
	end
end
function cm.sefilter(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.sethfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.sethfilter(c)
	return c:IsSetCard(0xc1) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.darwfilter(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,e:GetHandler())
end
function cm.disfilter(c)
	return c:IsSetCard(0xc1) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())) and c:IsAbleToGrave()
end



