--化石短吻鳄
function c10701474.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--race
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(RACE_REPTILE)
	c:RegisterEffect(e0)	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701474,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10701474)
	e1:SetTarget(c10701474.thtg)
	e1:SetOperation(c10701474.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--search2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701474,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_GRAVE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,10701475)
	e3:SetCondition(c10701474.thcon2)
	e3:SetTarget(c10701474.thtg2)
	e3:SetOperation(c10701474.thop2)
	c:RegisterEffect(e3)
end
function c10701474.thfilter(c)
	return c:IsLevelBelow(2) and c:IsRace(RACE_REPTILE+RACE_ROCK) and c:IsAbleToHand()
end
function c10701474.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701474.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701474.cfilter(c)
	return c:IsCode(59419719)
end
function c10701474.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_REPTILE+RACE_ROCK)
end
function c10701474.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701474.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c10701474.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c10701474.cfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(10701474,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c10701474.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function c10701474.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c10701474.thfilter2(c)
	return c:IsRace(RACE_REPTILE+RACE_ROCK) and c:IsAbleToHand()
end
function c10701474.disfilter(c)
	return c:IsSetCard(0x149) and c:IsAbleToGrave()
end
function c10701474.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() 
		and Duel.IsExistingMatchingCard(c10701474.disfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c10701474.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701474.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,c10701474.disfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	dg:AddCard(e:GetHandler())
	if Duel.SendtoGrave(dg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c10701474.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end