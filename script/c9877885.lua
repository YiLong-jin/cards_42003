--同心一力，无所难题
function c9877885.initial_effect(c)
	aux.AddCodeList(c,9877873,9877883)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9877885+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9877885.target)
	e1:SetOperation(c9877885.activate)
	c:RegisterEffect(e1)
end
function c9877885.ckfil(c) 
	return c:IsFaceup() and c:IsCode(9877873)   
end 
function c9877885.thfilter(c)
	return aux.IsCodeListed(c,9877883) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9877885.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877885.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877885.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c9877885.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		if Duel.IsExistingMatchingCard(c9877885.ckfil,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9877885,0)) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9877885,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		else  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		end 
	end
end