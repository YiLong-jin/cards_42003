--王虫化身
function c10701911.initial_effect(c)
	aux.AddCodeList(c,10701896)  
	--spummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701911,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701911)
	e1:SetTarget(c10701911.target)
	e1:SetOperation(c10701911.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701911,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10701912)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10701911.thtg)
	e2:SetOperation(c10701911.thop)
	c:RegisterEffect(e2)   
end
function c10701911.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c10701911.atkfilter(c)
	return c:IsFaceup() and c:IsCode(10701896)
end
function c10701911.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and
		(Duel.IsExistingMatchingCard(c10701911.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(c10701911.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK)
end
function c10701911.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701911.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	if Duel.IsExistingMatchingCard(c10701911.atkfilter,tp,LOCATION_MZONE,0,1,nil) then
		g:Merge(Duel.GetMatchingGroup(c10701911.spfilter,tp,LOCATION_DECK,0,nil,e,tp))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=g:Select(tp,1,1,nil)
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c10701911.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,10701896) and c:IsAbleToHand()
end
function c10701911.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701911.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701911.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10701911.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10701911.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and aux.NecroValleyFilter()(tc) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end