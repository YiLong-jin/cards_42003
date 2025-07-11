--大灵峰的守护者
function c10001025.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)	
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,10001025,EVENT_TO_GRAVE)
	local custom_code2=aux.RegisterMergedDelayedEvent_ToSingleCard(c,10001025,EVENT_REMOVE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c10001025.tdtg)
	e1:SetOperation(c10001025.tdop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(custom_code2)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,10001025)
	e2:SetTarget(c10001025.sptg)
	e2:SetOperation(c10001025.spop)
	c:RegisterEffect(e2)
end
function c10001025.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x16b) and c:IsAbleToDeck() and c:IsReason(REASON_SYNCHRO)
		and c:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE)
end
function c10001025.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10001025.cfilter,1,nil,e)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,10001025)==0 end
	Duel.RegisterFlagEffect(tp,10001025,RESET_PHASE+PHASE_END,0,1)
	local g=eg:Filter(c10001025.cfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10001025.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10001025.filter(c,e,tp)
	return c:IsRace(RACE_WYRM) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
	and Duel.IsExistingMatchingCard(c10001025.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function c10001025.spfilter(c,e,tp)
	return c:IsSetCard(0x16b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) 
end
function c10001025.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10001025.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10001025.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10001025.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10001025.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10001025.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end