--铅之罗盘
function c10701496.initial_effect(c)
	aux.AddCodeList(c,10701151)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701496+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701496.sptg)
	e1:SetOperation(c10701496.spop)
	c:RegisterEffect(e1)
	--Destroy 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701496,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c10701496.drcon)
	e2:SetTarget(c10701496.drtg)
	e2:SetOperation(c10701496.drop)
	c:RegisterEffect(e2)
end
function c10701496.spfilter(c,e,tp)
	return (c:IsCode(10701165) or (c:IsSetCard(0x7c3) and c:IsLocation(LOCATION_HAND+LOCATION_REMOVED))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701496.filter(c)
	return c:IsCode(10701151) and c:IsFaceup()
end
function c10701496.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND+LOCATION_REMOVED 
		if Duel.IsExistingMatchingCard(c10701496.filter,tp,LOCATION_SZONE,0,1,nil) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c10701496.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK)
end
function c10701496.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_REMOVED 
	if Duel.IsExistingMatchingCard(c10701496.filter,tp,LOCATION_SZONE,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701496.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701496.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsCode(10701165)
end
function c10701496.thfilter(c)
	return c:IsAbleToDeck()
end
function c10701496.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c10701496.thfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c10701496.filter,tp,LOCATION_REMOVED,0,1,nil)		 
		and Duel.GetFlagEffect(tp,10701496)==0 end
	Duel.RegisterFlagEffect(tp,10701496,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10701496.thfilter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10701496.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if not og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then return end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
