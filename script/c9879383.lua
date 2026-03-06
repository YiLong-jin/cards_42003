--星辰偶像-九霄
function c9879383.initial_effect(c)
	
	c:EnableCounterPermit(0x7e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9879383,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(9879383)
	e4:SetCountLimit(1,9879383) 
	e4:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e4:SetTarget(c9879383.tgtg) 
	e4:SetOperation(c9879383.tgop) 
	c:RegisterEffect(e4) 
end
function c9879383.tgfil(c) 
	return c:IsAbleToHand() and (c:IsCode(9879385) or c:IsCode(9879386) or c:IsCode(9879388) or c:IsCode(9879389) )
end 
function c9879383.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879383.tgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c9879383.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879383.tgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end 
end 