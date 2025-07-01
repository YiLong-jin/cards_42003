--「A」ハック・ミステリーサークル
function c10700973.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10700973.target)
	e1:SetOperation(c10700973.activate)
	c:RegisterEffect(e1)   
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700973,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10700973.sumcost)
	e2:SetTarget(c10700973.sumtg)
	e2:SetOperation(c10700973.sumop)
	c:RegisterEffect(e2) 
end
c10700973.counter_add_list={0x100e}
function c10700973.thfilter(c)
	return c:IsSetCard(0xc) and c:IsAbleToHand()
end
function c10700973.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700973.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700973.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700973.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xc) then
		   local sg=tc:GetLevel()
		   local cg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x100e,1)
		   if sg==0 or cg:GetCount()==0 then return end
		   for i=1,sg do
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		   local ag=cg:Select(tp,1,1,nil)
		   ag:GetFirst():AddCounter(0x100e,1)
		   end
	   end
	end
end
function c10700973.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x100e,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x100e,2,REASON_COST)
end
function c10700973.sumfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsSummonable(true,nil)
end
function c10700973.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700973.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10700973.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700973.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end