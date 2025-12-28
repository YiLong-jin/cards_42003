--小彩羽
function c9877943.initial_effect(c)
	aux.AddCodeList(c,9877873)  
	--code
	aux.EnableChangeCode(c,9877873,LOCATION_MZONE+LOCATION_GRAVE)
	--dice 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(10,9877943) 
	e1:SetTarget(c9877943.dctg)
	e1:SetOperation(c9877943.dcop)
	c:RegisterEffect(e1)
end
c9877943.toss_dice=true 
function c9877943.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c9877943.dcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==6 then
		local sg=Duel.SelectMatchingCard(tp,function(c) return aux.IsCodeListed(c,9877873) end,tp,LOCATION_DECK,0,1,1,nil)  
		if sg:GetCount()>0 then 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	elseif dc>=1 and dc<=5 then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,c)
		return not aux.IsCodeListed(c,9877873) end) 
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end  
end





