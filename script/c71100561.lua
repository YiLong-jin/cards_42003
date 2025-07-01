--死者缝针
function c71100561.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100561+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c71100561.target)
	e1:SetOperation(c71100561.activate)
	c:RegisterEffect(e1)
end
function c71100561.pbfil(c,tp)
	return c:IsSetCard(0x7d7,0x7d8) and not c:IsPublic() and Duel.IsExistingMatchingCard(c71100561.thfil,tp,LOCATION_DECK,0,1,nil,c)
end
function c71100561.thfil(c,pc)
	return c:IsSetCard(0x7d7,0x7d8) and not c:IsCode(pc:GetCode()) and c:IsAbleToHand()
end
function c71100561.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100561.pbfil,tp,LOCATION_HAND,0,1,nil,tp) end 
	local pc=Duel.SelectMatchingCard(tp,c71100561.pbfil,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst() 
	Duel.ConfirmCards(1-tp,pc) 
	e:SetLabelObject(pc)
	Duel.ShuffleHand(tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71100561.spfil(c,e,tp)
	return c:IsSetCard(0x7d8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c71100561.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local pc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c71100561.thfil,tp,LOCATION_DECK,0,1,1,nil,pc):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local xtable={aux.Stringid(71100561,3)} 
		local b1=c:IsRelateToEffect(e) and Duel.IsPlayerCanSendtoHand(tp,c) 
		local b2=Duel.IsExistingMatchingCard(c71100561.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		if b1 then table.insert(xtable,aux.Stringid(71100561,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(71100561,2)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if xtable[op]==aux.Stringid(71100561,1) then 
			c:CancelToGrave() 
			Duel.SendtoHand(c,nil,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,c)
		end  
		if xtable[op]==aux.Stringid(71100561,2) then 
			local sc=Duel.SelectMatchingCard(tp,c71100561.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		end  
	end
end

