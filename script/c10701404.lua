--幻兽机 柯蒂斯蝠鲼
function c10701404.initial_effect(c)
	aux.AddCodeList(c,31533705)
	c:SetSPSummonOnce(10701404)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c10701404.mzfilter,1,1)  
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701404,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c10701404.thtg)
	e1:SetOperation(c10701404.thop)
	c:RegisterEffect(e1)  
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16943770,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10701404.spcon)
	e4:SetCost(c10701404.spcost)
	e4:SetTarget(c10701404.sptg)
	e4:SetOperation(c10701404.spop)
	c:RegisterEffect(e4)
end
function c10701404.mzfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and not c:IsSummonableCard()
end
function c10701404.thfilter(c)
	return c:IsAbleToHand() and (aux.IsCodeListed(c,31533705) or c:IsCode(904185,4417407,6260554,15335853,16943770,20368763,22110647,26949946,30811116,31480215,31533704,41329458,44026393,44097050,66200210,67489919,67922702,70875955,72291078,76902476,83054225,94973028))
end
function c10701404.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701404.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701404.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701404.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10701404.spfilter(c)
	return c:IsFaceup() and c:IsCode(31533705)
end
function c10701404.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10701404.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10701404.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c10701404.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c10701404.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701404.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c10701404.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,31533705,0x101b,TYPES_TOKEN_MONSTER,0,0,3,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10701404.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,31533705,0x101b,TYPES_TOKEN_MONSTER,0,0,3,RACE_MACHINE,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,10701405)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end