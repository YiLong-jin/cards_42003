--トリオキシゲドン
function c10701506.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,58071123,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701506,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10701506)
	e1:SetCondition(c10701506.spcon)
	e1:SetTarget(c10701506.sptg)
	e1:SetOperation(c10701506.spop)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701506,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,10701507)
	e2:SetTarget(c10701506.tgtg)
	e2:SetOperation(c10701506.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c10701506.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)&ATTRIBUTE_FIRE>0
end
function c10701506.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10701506.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c10701506.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DINOSAUR) and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER) and c:IsAbleToGrave()
end
function c10701506.thfilter(c,mc)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_MONSTER) and c:IsAttribute(mc:GetAttribute()) and not c:IsLevel(mc:GetLevel()) and c:IsAbleToHand()
end
function c10701506.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701506.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10701506.cfilter(c)
	return c:IsRace(RACE_DRAGON+RACE_SEASERPENT)
end
function c10701506.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701506.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local tg=Duel.GetMatchingGroup(c10701506.thfilter,tp,LOCATION_DECK,0,nil,g:GetFirst())
		if tg:GetCount()>0 and Duel.IsExistingMatchingCard(c10701506.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10701506,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end