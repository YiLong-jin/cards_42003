--小勇士 璃拉
function c65843071.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,61976639)
	c:SetSPSummonOnce(65843071)	
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x153),1,1)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65843071,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,65843071)
	e1:SetCondition(c65843071.thcon)
	e1:SetCost(c65843071.thcost)
	e1:SetTarget(c65843071.thtg)
	e1:SetOperation(c65843071.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65843071,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65843071)
	e2:SetCondition(c65843071.condition)
	e2:SetTarget(c65843071.sptg2)
	e2:SetOperation(c65843071.spop2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(65843071,ACTIVITY_SPSUMMON,c65843071.counterfilter)
end
function c65843071.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_LINK) and c:IsRace(RACE_FIEND))
end
function c65843071.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65843071.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65843071,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65843071.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65843071.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_LINK) and c:IsRace(RACE_FIEND)) and c:IsLocation(LOCATION_EXTRA)
end
function c65843071.thfilter(c)
	return c:IsCode(61976639) and c:IsAbleToHand()
end
function c65843071.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65843071.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65843071.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c65843071.thfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--[[function c65843071.rmfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c65843071.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c65843071.rmfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,0,g:GetCount(),nil)
	if #sg==0 or Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	og=og-og:Filter(Card.IsReason,nil,REASON_REDIRECT)
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(65843071,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(c65843071.retcon)
	e1:SetOperation(c65843071.retop)
	Duel.RegisterEffect(e1,tp)
end
function c65843071.retfilter(c,tp)
	return c:GetFlagEffect(65843071)~=0 and (not tp or c:IsControler(tp))
end
function c65843071.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():IsExists(c65843071.retfilter,1,nil,nil) then
		e:GetLabelObject():DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function c65843071.returngroup(g,tp)
	if #g==0 then return end
	local c
	while #g>1 and Duel.GetMZoneCount(tp)>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		c=g:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(c)
		g=g-c
	end
	for oc in aux.Next(g) do
		Duel.ReturnToField(oc)
	end
end
function c65843071.retop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g1=e:GetLabelObject():Filter(c65843071.retfilter,nil,turnp)
	local g2=e:GetLabelObject():Filter(c65843071.retfilter,nil,1-turnp)
	if #g1+#g2==0 then return end
	c65843071.returngroup(g1,turnp)
	c65843071.returngroup(g2,1-turnp)
end
function c65843071.spfilter(c,e,tp)
	return c:IsSetCard(0x1151) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65843071.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65843071.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c65843071.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65843071.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end]]
function c65843071.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c65843071.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x153) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65843071.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and c65843071.spfilter2(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65843071.spfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65843071.spfilter2,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65843071.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_EFFECT)		
	end
end