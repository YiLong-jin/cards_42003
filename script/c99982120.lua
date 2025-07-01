--神谕造物 格拉基的触须
local m=99982120
local cm=_G["c"..m]
function cm.initial_effect(c)
		--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99982120,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,99982120)
	e2:SetCondition(c99982120.spcon)
	e2:SetTarget(c99982120.sptg)
	e2:SetOperation(c99982120.spop)
	c:RegisterEffect(e2)
	
	
		--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
		e4:SetCountLimit(1,99982121)
	e4:SetTarget(c99982120.rmtg)
	e4:SetOperation(c99982120.rmop)
	c:RegisterEffect(e4)
	
	
	
	
	
	
end
function c99982120.filters(c)
	return c:IsFaceup() and c:IsCode(99982190)
end
function c99982120.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c99982120.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=1
	if Duel.IsExistingMatchingCard(c99982120.filters,tp,LOCATION_MZONE,0,1,nil) then
		tg=2
		if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c:IsAbleToRemove() end
		if chk==0 then  return Duel.IsExistingTarget(c99982120.cfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and c:IsAbleToRemove()  end
	else
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c:IsAbleToRemove() end
		if chk==0 then  return Duel.IsExistingTarget(c99982120.cfilter,tp,0,LOCATION_GRAVE,1,nil) and c:IsAbleToRemove()  end   
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if Duel.IsExistingMatchingCard(c99982120.filters,tp,LOCATION_MZONE,0,1,nil) then
	   local g=Duel.SelectTarget(tp,c99982120.cfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,tg,nil)
	   Duel.SetChainLimit(c99982120.chlimit)
	else
	   local g=Duel.SelectTarget(tp,c99982120.cfilter,tp,0,LOCATION_GRAVE,1,tg,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,tg,0,0)
end
function c99982120.chlimit(e,ep,tp)
	return tp==ep
end
function c99982120.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		tg:AddCard(e:GetHandler())
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end





















function c99982120.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99982120.spfilter(c,e,tp)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0x66d)
end
function c99982120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99982120.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99982120.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c99982120.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ConfirmCards(1-tp,tc)
	end
end



