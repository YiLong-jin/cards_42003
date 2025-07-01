--万圣夜想曲 捣乱☆后辈
function c10700814.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FLIP),1,1) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700814,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10700814)
	e1:SetCondition(c10700814.thcon)
	e1:SetTarget(c10700814.thtg)
	e1:SetOperation(c10700814.thop)
	c:RegisterEffect(e1)   
end
function c10700814.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10700814.handfilter(c)
	return not c:IsPublic()
end
function c10700814.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700814.handfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c10700814.thfilter(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c10700814.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c10700814.handfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c10700814.handfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10700801,4))
		local thg=Duel.GetMatchingGroup(c10700814.thfilter,tp,LOCATION_DECK,0,nil)
		if (tc:IsSetCard(0x7c9) or tc:IsType(TYPE_FLIP)) and thg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700814,1)) then 
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local sg=thg:Select(tp,1,1,nil)
		   Duel.SendtoHand(sg,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,sg)
		end
   end
end