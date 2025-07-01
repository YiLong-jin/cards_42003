--暗金秘术·魔法药水
function c2222712.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52155219+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c2222712.target)
	e1:SetOperation(c2222712.activate)
	c:RegisterEffect(e1)
end

function c2222712.thfilter(c)
	return c:IsSetCard(0x257) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end

function c2222712.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end

	local b1=Duel.IsExistingMatchingCard(c2222712.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(2222712,0),aux.Stringid(2222712,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(2222712,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(2222712,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	end
end
function c2222712.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c2222712.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c2222712.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(600)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
	end
	
end
function c2222712.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end





