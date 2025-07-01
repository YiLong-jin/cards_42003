--侵蚀V城的黯影
local m=71100027
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DESTROY+CATEGORY_CONTROL+CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.gravefilter(c)
	return c:IsSetCard(0x7d1) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.removefilter(c)
	return c:IsSetCard(0x7d1) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cm.disfilter(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.gravefilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.removefilter,tp,LOCATION_HAND,0,1,nil)
end
function cm.desfilter(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.gravefilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(cm.removefilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.confilter(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.gravefilter,tp,LOCATION_HAND,0,2,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and (cm.disfilter(e) or cm.desfilter(e) or cm.confilter(e)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local off=1
	local ops={}
	local opval={}
	if cm.disfilter(e) and aux.disfilter1(tc) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if cm.desfilter(e) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if cm.confilter(e) then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,cm.gravefilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,cm.removefilter,tp,LOCATION_HAND,0,1,1,nil)
		if Duel.SendtoGrave(gg,REASON_EFFECT) and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) then
			Duel.BreakEffect()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,cm.gravefilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,cm.removefilter,tp,LOCATION_DECK,0,1,1,nil)
		if Duel.SendtoGrave(gg,REASON_EFFECT) and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,cm.gravefilter,tp,LOCATION_HAND,0,2,2,nil)
		if Duel.SendtoGrave(gg,REASON_EFFECT)==2 and Duel.GetControl(tc,tp,PHASE_END,1+Duel.GetTurnPlayer())~=0 then
			local e1=Effect.CreateEffect(c)
			local reset=RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CONTROL+RESET_PHASE+PHASE_END 
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetReset(reset,1+Duel.GetTurnPlayer())
			tc:RegisterEffect(e4)
		end
	end
end