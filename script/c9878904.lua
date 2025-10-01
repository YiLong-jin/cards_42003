--叛逆之城-赤星市
function c9878904.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,9878904+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9878904.activate)
	c:RegisterEffect(e1) 


	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c9878904.cost1)
	e2:SetCountLimit(1,1878904)
	e2:SetTarget(c9878904.sptg)
	e2:SetOperation(c9878904.spop)
	c:RegisterEffect(e2) 

	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTargetRange(1,0)
	e12:SetTarget(c9878904.splimit)
	c:RegisterEffect(e12)

	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CHANGE_RACE)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetValue(RACE_MACHINE)
	c:RegisterEffect(e12)
end
function c9878904.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x17ec)
end

function c9878904.thfilter(c)
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9878904.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9878904.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9878904,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c9878904.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9878904.spfilter(c,e,tp)
	return c:IsSetCard(0x17ec) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9878904.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9878904.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9878904.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9878904.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 