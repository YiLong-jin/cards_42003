--断罪神的律法书
function c10701660.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701660+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10701660.activate)
	c:RegisterEffect(e1)  
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701660,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10701660.opcon)
	e3:SetTarget(c10701660.optg)
	e3:SetOperation(c10701660.opop)
	c:RegisterEffect(e3) 
end
function c10701660.filter(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToGrave()
end
function c10701660.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701660.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701660,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c10701660.cfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()==2800 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10701660.opcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and eg:IsExists(c10701660.cfilter,1,nil)
end
function c10701660.thfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c10701660.spfilter(c,e,tp)
	return (c:IsSetCard(0x7c0) or c:IsCode(24857466)) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701660.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c10701660.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.GetFlagEffect(tp,10701660)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701660.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,10701661)==0
	if chk==0 then return b1 or b2 end
end
function c10701660.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c10701660.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.GetFlagEffect(tp,10701660)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701660.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,10701661)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(10701660,1),aux.Stringid(10701660,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(10701660,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(10701660,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701660.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
		Duel.RegisterFlagEffect(tp,10701660,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701660.spfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,10701661,RESET_PHASE+PHASE_END,0,1)
	end
end