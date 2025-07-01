--狩魂×导教
function c69969422.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969422,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,69969422+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c69969422.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969422,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,69969415)
	e3:SetTarget(c69969422.mattg)
	e3:SetOperation(c69969422.matop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969422,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,69969415)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c69969422.tdtg)
	e2:SetOperation(c69969422.tdop)
	c:RegisterEffect(e2)
	end
	function c69969422.ngthfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x69d) and c:IsAbleToHand()
end
function c69969422.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c69969422.ngthfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(69969422,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--2
function c69969422.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0x69d)
end
function c69969422.matfilter(c)
	return c:IsSetCard(0x69d) and c:IsCanOverlay()
end
function c69969422.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c69969422.tgfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c69969422.tgfilter,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c69969422.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local g=eg
	if #eg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=eg:FilterSelect(tp,c69969422.tgfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c69969422.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c69969422.matfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
			Duel.Damage(tp,500,REASON_EFFECT)
		end
	end
end
--3
function c69969422.getfilter(c)
	return (c:IsSetCard(0x69d) or c:IsRace(RACE_SPELLCASTER)) and c:IsAbleToDeck()
end
function c69969422.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(c69969422.getfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c69969422.getfilter,tp,LOCATION_GRAVE,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c69969422.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end