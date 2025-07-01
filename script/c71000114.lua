--臆想恶念的无端指控
local m=71000114
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsFaceup() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			local og=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,tc:GetCode()):Filter(Card.IsAbleToGrave,nil)
			if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sc=og:Select(tp,1,1,nil)
				if sc then Duel.SendtoGrave(sc,REASON_EFFECT) end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			local ac=Duel.AnnounceCard(tp)
			Duel.ConfirmCards(tp,tc)
			if tc:IsCode(ac) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			else
				local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end











