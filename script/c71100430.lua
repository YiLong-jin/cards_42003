--死魂棋子 狄密特
local s,id,o=GetID()
function s.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon1)
	e1:SetTarget(s.destg1)
	e1:SetOperation(s.desop1)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCountLimit(1,id+o)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_EQUIP)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.Dead_souls_pawn=true --「死魂棋子」记述
function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.desfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsLocation(LOCATION_GRAVE) or c:IsAbleToDeck())
end
function s.desfilter2(c,e)
	return c.Dead_souls_pawn and c:IsType(TYPE_MONSTER) and c:IsDestructable(e)
end
function s.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter2,tp,LOCATION_DECK,0,nil,e)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(1-tp) and s.desfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and #g>0 and c:IsDestructable(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,s.desfilter1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	if sg:GetFirst():IsLocation(LOCATION_REMOVED) then 
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
	end
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function s.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter2,tp,LOCATION_DECK,0,1,1,nil,e)
	local tc=Duel.GetFirstTarget()
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_REMOVED) then 
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		elseif tc:IsLocation(LOCATION_GRAVE) and not g:GetFirst():IsLocation(LOCATION_HAND+LOCATION_DECK) then 
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x7d7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(250)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end