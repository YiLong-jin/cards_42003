--冰之女王 八千代
function c9878038.initial_effect(c)
	 aux.AddCodeList(c,9877883)

	 aux.EnableChangeCode(c,9877883,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9878038,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,9878038)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c9878038.condition)
	e3:SetTarget(c9878038.thtg(c9878038.ifilter))
	e3:SetOperation(c9878038.thop(c9878038.ifilter))
	c:RegisterEffect(e3)
end
function c9878038.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end
function c9878038.ifilter(c)
	return aux.IsCodeListed(c,9877883) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9878038.thtg(f)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_DECK,0,1,nil) end
				Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			end
end
function c9878038.thop(f)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
end
