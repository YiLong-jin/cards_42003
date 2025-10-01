--超可爱执行者的培徽
function c65846911.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e0:SetCondition(c65846911.subcon)
	e0:SetValue(c65846911.subval)
	c:RegisterEffect(e0)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,65846911)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65846911.condition)
	e2:SetTarget(c65846911.tgtg)
	e2:SetOperation(c65846911.tgop)
	c:RegisterEffect(e2)
end
c65846911.SetCard_ZJ_CKAZXZ=true
function c65846911.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
end
function c65846911.subval(e,c)
	return c.SetCard_ZJ_CKAZXZ
end
function c65846911.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end

function c65846911.tgfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsAbleToGrave()
end
function c65846911.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846911.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65846911.thfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(0x6) and c:IsAbleToHand()
end
function c65846911.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846911.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c65846911.thfilter),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65846911,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end