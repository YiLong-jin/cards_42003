--超天斎 白田级战列舰
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),aux.NonTuner(Card.IsRace,RACE_PYRO),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+1)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--SynchroSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.syncon)
	e2:SetTarget(cm.syntg)
	e2:SetOperation(cm.synop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.damcon)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x7dc) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.syncon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 then return false end
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_PYRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.synfilter(c,g)
	return c:IsRace(RACE_PYRO) and c:IsSynchroSummonable(nil,g)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 and (ft<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) or (not Duel.IsPlayerCanSpecialSummonCount(tp,2))) then return false end
	local g1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local sychk=false 
	for tc in aux.Next(g1) do
		for mc in aux.Next(g2) do 
			if Duel.IsExistingMatchingCard(cm.synfilter,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(tc,mc)) then
				sychk=true 
				break 
			end
		end
		if sychk then break end
	end
	if chk==0 then return sychk end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1:Merge(g2),2,0,0)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g=Group.CreateGroup()
	for tc in aux.Next(g1) do
		for mc in aux.Next(g2) do 
			if Duel.IsExistingMatchingCard(cm.synfilter,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(tc,mc)) then
				g:AddCard(tc)
			end
		end
	end
	if #g<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	g=Group.CreateGroup()
	for mc in aux.Next(g2) do 
		if Duel.IsExistingMatchingCard(cm.synfilter,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(tc,mc)) then
			g:AddCard(mc)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:Select(tp,1,1,nil)
	local mc=g:GetFirst()
	local og=Group.FromCards(tc,mc)
	Duel.SpecialSummon(og,0,tp,tp,false,false,POS_FACEUP)
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)~=2 then return end
	local tg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_EXTRA,0,nil,og)
	if tg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(84815190,3))
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_PYRO)
	local dam=g:GetClassCount(Card.GetCode)*400
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_PYRO)
	local dam=g:GetClassCount(Card.GetCode)*400
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end