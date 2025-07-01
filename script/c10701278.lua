--灰篮UFO
function c10701278.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DECKDES)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,10701278+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(c10701278.activate)
	c:RegisterEffect(e0)  
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c10701278.tgcon)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0xff,0xff) 
	e3:SetCondition(c10701278.tgcon)
	e3:SetTarget(c10701278.tglimit)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701278,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10701279)
	e4:SetCondition(c10701278.thcon)
	e4:SetTarget(c10701278.thtg)
	e4:SetOperation(c10701278.thop)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(712559,0))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,10701279)
	e5:SetCondition(c10701278.thcon2)
	e5:SetTarget(c10701278.thtg)
	e5:SetOperation(c10701278.thop)
	c:RegisterEffect(e5)
end
function c10701278.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701278.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701278.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701278,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701278.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd1)
end
function c10701278.tgcon(e)
	return Duel.IsExistingMatchingCard(c10701278.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c10701278.tglimit(e,c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and not c:IsSetCard(0xd1)
end
function c10701278.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c10701278.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_AQUA) and c:IsAbleToHand()
end
function c10701278.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701278.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701278.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701278.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10701278.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsPreviousControler(tp)
end
function c10701278.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701278.filter,1,nil,tp)
end