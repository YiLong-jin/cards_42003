--神滨奇妙夜
function c99900590.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
------------------------------------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99900590,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(c99900590.exstg)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e2)
------------------------------------------------------------------------------------------------------------------------------------------------
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99900590,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,99900590)
	e3:SetCondition(c99900590.drcon)
	e3:SetTarget(c99900590.drtg)
	e3:SetOperation(c99900590.drop)
	c:RegisterEffect(e3)
------------------------------------------------------------------------------------------------------------------------------------------------
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c99900590.thtg)
	e4:SetOperation(c99900590.thop)
	c:RegisterEffect(e4)
------------------------------------------------------------------------------------------------------------------------------------------------
end
function c99900590.exstg(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900590.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x676) and c:IsType(TYPE_FUSION)
		and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c99900590.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99900590.cfilter,1,nil,tp)
end
function c99900590.filter(c)
	return c:IsCode(99900600) or (c:IsSetCard(0x676) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c99900590.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900590.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99900590.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99900590.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900590.thfilter(c,id)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_MONSTER) and c:GetTurnID()==id and c:IsAbleToHand() and c:IsFaceup()
end
function c99900590.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c99900590.thfilter(chkc,tid) end
	if chk==0 then return Duel.IsExistingTarget(c99900590.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99900590.thfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,tid)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99900590.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end