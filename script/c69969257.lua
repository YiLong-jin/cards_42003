--四季·荟萃
function c69969257.initial_effect(c)
 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c69969257.gactivate)
	c:RegisterEffect(e1)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969257,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,69969257)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c69969257.cdcon)
	e4:SetTarget(c69969257.tgtg)
	e4:SetOperation(c69969257.tgop)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969257,1))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_MAIN_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,69969257)
	e5:SetCondition(c69969257.ddcon)
	e5:SetTarget(c69969257.ntarget)
	e5:SetOperation(c69969257.activate)
	c:RegisterEffect(e5)
end
--0
function c69969257.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x669b) and bit.band(TYPE_MONSTER,c:GetOriginalType())~=0
end
--1
function c69969257.thfilter(c)
	return c:IsSetCard(0x69b) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c69969257.gactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c69969257.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(69969257,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--2
function c69969257.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c69969257.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil) 
end
function c69969257.spfilter(c,e,tp)
	return c:IsSetCard(0x669b) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69969257.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c69969257.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c69969257.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c69969257.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--4
function c69969257.ddcon(e,tp,eg,ep,ev,re,r,rp)
local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c69969257.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c69969257.gxfilter(c)
	return c:IsSetCard(0x669b) and c:IsFaceup() and c:IsCanAddCounter(0x169b,1)
end
function c69969257.ntarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969257.gxfilter,tp,LOCATION_ONFIELD,0,1,nil,0x169b,1) end
end
function c69969257.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c69969257.gxfilter,tp,LOCATION_ONFIELD,0,nil,0x169b,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x169b,1) 
		tc=g:GetNext()
		end
end