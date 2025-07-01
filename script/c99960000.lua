--博丽天守大结界
function c99960000.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99960000+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c99960000.activate)
	c:RegisterEffect(e1)
		--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTarget(c99960000.rmtg)
	e2:SetTargetRange(0xff,0xff)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e2)
end
function c99960000.rmtg(e,c)
	return c:IsSetCard(0x66f)
end
function c99960000.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x66f) and c:IsAbleToHand()
end
function c99960000.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99960000.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99960000,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end