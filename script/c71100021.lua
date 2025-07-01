--RC公司介入中
local m=71100021
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost) 
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thac)  
	c:RegisterEffect(e1) 
	--XyzSummon
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_ACTIVATE)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.xyztg)  
	e2:SetOperation(cm.xyzac)  
	c:RegisterEffect(e2) 
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.costfilter(c)
	return c:IsSetCard(0x7d0) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0x7d0) and c:IsAbleToHand(c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x7d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thac(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT) then 
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsSetCard,0x7d0),tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc_sp=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tc_sp,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function cm.xyzfilter(c)
	return c:IsXyzSummonable(nil) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(nil)
end
function cm.xyzac(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sz=g:Select(tp,1,1,nil):GetFirst()
	if not sz then return end
	Duel.XyzSummon(tp,sz,nil)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.xyzmfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.xyzmfilter),1-tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local x1_g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.xyzmfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		local x2_g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.xyzmfilter),1-tp,LOCATION_GRAVE,0,1,1,nil)
		x1_g:Merge(x2_g)
		Duel.Overlay(sz,x1_g)
	end
end












