--魔石诅咒
function c9879262.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879262,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_COUNTER+CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9879262+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9879262.sptg)
	e1:SetOperation(c9879262.spop)
	c:RegisterEffect(e1)
end

function c9879262.filter1(c,e,tp)
	return c:IsSetCard(0x27e3) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9879262.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x107e,1)  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x107e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x107e,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x107e)
end
function c9879262.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c9879262.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x107e,1) then
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9879262,0))  then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		end 
	end  
end
