--黑岩射手·祈愿
function c69969017.initial_effect(c)
aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x699),4,2)
	c:EnableReviveLimit()  
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969017,0))
	e1:SetCategory(CATEGORY_TODECK+EFFECT_FLAG_CARD_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c69969017.tgcost)
	e1:SetTarget(c69969017.drtg)
	e1:SetOperation(c69969017.drop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969017,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+EFFECT_FLAG_CARD_TARGET)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,69969017)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c69969017.cost)
	e2:SetTarget(c69969017.sptg)
	e2:SetOperation(c69969017.spop)
	c:RegisterEffect(e2)
end
--1
function c69969017.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c69969017.tdfilter(c)
	return c:IsAbleToDeck()
end
function c69969017.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c69969017.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69969017.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c69969017.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c69969017.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
end
--2
function c69969017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c69969017.filter(c,e,tp)
	return c:IsSetCard(0x699) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(69969017)
end
function c69969017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69969017.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c69969017.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c69969017.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c69969017.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
	end
end