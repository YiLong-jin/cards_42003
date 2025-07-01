--远古邓氏鱼
function c10701476.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701476,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,10701476)
	e1:SetTarget(c10701476.thtg)
	e1:SetOperation(c10701476.thop)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EVENT_TO_GRAVE)
	e1x:SetCondition(c10701476.thcon)
	c:RegisterEffect(e1x)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701476,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10701477)
	e2:SetCondition(c10701476.spcon)
	e2:SetTarget(c10701476.sptg)
	e2:SetOperation(c10701476.spop)
	c:RegisterEffect(e2)
end
function c10701476.thfilter(c)
	if not c:IsAbleToHand() then return false end
	return c:IsCode(59419719) or (aux.IsCodeListed(c,59419719) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c10701476.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c10701476.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701476.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701476.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701476.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10701476.spcfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsFaceup()
end
function c10701476.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10701476.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10701476.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701476.filter(c)
	return c:IsCode(59419719) and c:IsAbleToHand()
end
function c10701476.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 
		  and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,59419719) 
		  and Duel.SelectYesNo(tp,aux.Stringid(10701476,2)) then
			local tg=Duel.GetMatchingGroup(c10701476.filter,tp,LOCATION_GRAVE,0,nil)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=tg:Select(tp,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end