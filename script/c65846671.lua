--AIくまキャン
local m=65846671
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,65846670,65846684)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,65846671)
	e0:SetTarget(cm.thtr1)
	e0:SetOperation(cm.thop1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,65846671)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.thtr2)
	e1:SetOperation(cm.thop2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.ffilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PSYCHO) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function cm.thfilter(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsAbleToHand()
end
function cm.thtr2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_EXTRA,0,1,nil,tp) end --and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsCode(24094653) end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsAbleToHand() and c:IsCode(24094653) end),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local exg=Duel.GetMatchingGroup(cm.ffilter3,tp,LOCATION_EXTRA,0,nil,tp)
	if exg:GetCount()>0 then
		local tc=Duel.SelectMatchingCard(tp,cm.ffilter3,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local fc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc):GetFirst()
		if not fc then return end
		if Duel.SendtoHand(fc,nil,REASON_EFFECT)==0 then return end
		Duel.ConfirmCards(1-tp,fc)
		if g:GetCount()>0 and fc:IsType(TYPE_NORMAL) and fc:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.ffilter3(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_PSYCHO) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function cm.thfilter2t(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function cm.fselect2(g)
	return g:FilterCount(cm.thfilter2t,nil)>0
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetCode)>=2
end
function cm.thtr1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(3) and c:IsType(TYPE_NORMAL) end,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():IsDiscardable() and g:GetClassCount(Card.GetCode)>=1 end
	e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop1(e,tp,rg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)==0 then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(function(c) return c:IsAbleToHand() and c:IsRace(RACE_PSYCHO) and c:IsLevelBelow(3) and c:IsType(TYPE_NORMAL) end),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c) return c:IsAbleToHand() and c:IsCode(24094653) end),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if tc:IsCode(65846684,65846670) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(function(c) return c:IsAbleToHand() and c:IsCode(24094653) end),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end