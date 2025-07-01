--神谕造物 贤者之石
local m=99982110
local cm=_G["c"..m]
function cm.initial_effect(c)
		--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99982110,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,99982110)
	e2:SetCondition(c99982110.spcon)
	e2:SetTarget(c99982110.sptg)
	e2:SetOperation(c99982110.spop)
	c:RegisterEffect(e2)
	
	
	
		local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(c99982110.cost)
	e3:SetTarget(c99982110.target)
	e3:SetOperation(c99982110.activate)
	c:RegisterEffect(e3)
	
	
	
	
	
end
function c99982110.filter(c,e,tp,mg)
	if c:GetLevel()>4 then return false end
	local ct=math.floor(c:GetLevel())
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x66d) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and mg:CheckSubGroup(c99982110.gcheck,ct,ct,tp,c)
end
function c99982110.gcheck(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
		and g:FilterCount(Card.IsAbleToGrave,nil)==g:GetCount()
end
function cm.thfilter(c)
	return c:IsSetCard(0x366d) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return c:IsSetCard(0x666d) and c:IsAbleToHand()
end
function cm.thfilter3(c)
	return c:IsSetCard(0x566d) and c:IsAbleToHand()
end
function c99982110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99982110.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c99982110.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x66d) and c:IsLocation(LOCATION_EXTRA)
end




function c99982110.tgfilter(c)
	return c:IsAbleToGrave() and (c:IsRace(RACE_BEASTWARRIOR) or c:IsRace(RACE_DRAGON) or c:IsRace(RACE_FAIRY))
end
function c99982110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99982110.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c99982110.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x66d)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99982110.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local b1=tc:IsRace(RACE_BEASTWARRIOR) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		local b2=tc:IsRace(RACE_DRAGON) and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,e,tp)
		local b3=tc:IsRace(RACE_FAIRY) and Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_DECK,0,1,nil,e,tp)
		if b1 and Duel.SelectYesNo(tp,aux.Stringid(99982110,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c99982110.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
			Duel.SpecialSummonComplete()
		end
		if b2 and Duel.SelectYesNo(tp,aux.Stringid(99982110,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=Duel.SelectMatchingCard(tp,c99982110.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g3:GetCount()>0 then
			Duel.SendtoHand(g3,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g3)
		end
			Duel.SpecialSummonComplete()
		end
		if b3 and Duel.SelectYesNo(tp,aux.Stringid(99982110,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g4=Duel.SelectMatchingCard(tp,c99982110.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
		if g4:GetCount()>0 then
			Duel.SendtoHand(g4,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g4)
		end
			Duel.SpecialSummonComplete()
		end
	end
end





















function c99982110.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99982110.spfilter(c,e,tp)
	return c:IsRace(RACE_ILLUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0x66d)
end
function c99982110.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99982110.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99982110.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c99982110.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ConfirmCards(1-tp,tc)
	end
end










