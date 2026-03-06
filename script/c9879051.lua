--星变偶像·超
function c9879051.initial_effect(c)
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

	
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(9879051,0))
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e21:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e21:SetCode(EVENT_SUMMON_SUCCESS)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCountLimit(1,9879051)
	e21:SetTarget(c9879051.thtg)
	e21:SetOperation(c9879051.thop)
	c:RegisterEffect(e21)
	local e23=e21:Clone()
	e23:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e23)  
end
function c9879051.tgfil(c) 
	return c:IsAbleToHand() and c:IsCanHaveCounter(0x7e2) and c:IsType(TYPE_MONSTER)
end 
function c9879051.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879051.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c9879051.thop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879051.tgfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end 
end 