--休息一下
function c65840060.initial_effect(c)
	aux.AddCodeList(c,65842060)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65840060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65840060.target)
	e1:SetOperation(c65840060.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65840060,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65840060.tdtg)
	e2:SetOperation(c65840060.tdop)
	c:RegisterEffect(e2)
end
function c65840060.cfilter(c)
	return c:IsFaceup() and c:IsCode(65842060)
end
function c65840060.filter1(c,e,tp)
	return c:IsCode(65842060) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65840060.filter2(c,e,tp)
	return (aux.IsCodeListed(c,65842060) or c:IsCode(65842060)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65840060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if not Duel.IsExistingMatchingCard(c65840060.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			return Duel.IsExistingMatchingCard(c65840060.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c65840060.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c65840060.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if not Duel.IsExistingMatchingCard(c65840060.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		g=Duel.SelectMatchingCard(tp,c65840060.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	else
		g=Duel.SelectMatchingCard(tp,c65840060.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65840060.tdfilter(c)
	return (aux.IsCodeListed(c,65842060) or c:IsCode(65842060) or c:IsType(TYPE_SYNCHRO)) and c:IsType(0x1) and c:IsAbleToDeck() and c:IsFaceup()
end
function c65840060.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c65840060.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65840060.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.GetFlagEffect(tp,65840060)==0 end
	Duel.RegisterFlagEffect(tp,65840060,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65840060.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c65840060.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end