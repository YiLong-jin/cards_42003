--灾难等级A-凝视者
function c9877360.initial_effect(c)
	--des and sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9877360) 
	e1:SetTarget(c9877360.desptg) 
	e1:SetOperation(c9877360.despop) 
	c:RegisterEffect(e1) 
	--to grave 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1877360) 
	e2:SetCost(c9877360.tgcost)
	e2:SetTarget(c9877360.tgtg) 
	e2:SetOperation(c9877360.tgop) 
	c:RegisterEffect(e2) 
end
function c9877360.desfil(c,e,tp) 
	return Duel.GetMZoneCount(tp,c)>0  
end 
function c9877360.desptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9877360.desfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	local g=Duel.SelectTarget(tp,c9877360.desfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c9877360.despop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)	
	end 
end 
function c9877360.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST) 
end 
function c9877360.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0x27e4) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c9877360.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:IsSetCard(0x27e4) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(9877360,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,TYPE_MONSTER)  
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end 
end  












