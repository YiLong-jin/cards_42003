--星变偶像·阿玛莉娅
function c9879056.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)


	
	 local e24=Effect.CreateEffect(c)
	e24:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e24:SetType(EFFECT_TYPE_IGNITION)
	e24:SetRange(LOCATION_HAND)
	e24:SetCountLimit(1,9879056) 
	e24:SetCost(c9879056.srcost1)
	e24:SetTarget(c9879056.srtg1)
	e24:SetOperation(c9879056.srop1)
	c:RegisterEffect(e24) 
end
function c9879056.srcost1(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end  
function c9879056.tgfil1(c)
	return c:IsCanHaveCounter(0x7e2) and c:IsAbleToHand() and not c:IsCode(9879056)
end
function c9879056.srtg1(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c9879056.tgfil1,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9879056.srop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c9879056.tgfil1,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil) 
	if g1:GetCount()>0 then 
		local sg1=g1:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg1)
	end 
end 