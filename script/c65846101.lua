--彩虹 彩心
function c65846101.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846101,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65846101+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c65846101.spscon)
	c:RegisterEffect(e1)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c65846101.thcon)
	e3:SetTarget(c65846101.thtg)
	e3:SetOperation(c65846101.thop)
	c:RegisterEffect(e3)
end
c65846101.SetCard_ZJ_CH=true
function c65846101.filter(c)
	return c:IsFaceup() and c:IsRace(0x4)-- and c:IsType(TYPE_TUNER)
end
function c65846101.spscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846101.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c65846101.thfilter(c)
	return c:IsRace(0x4) and c:IsAbleToHand() and c:IsLevelBelow(2)
end
function c65846101.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and rc:IsRace(RACE_FAIRY)
end
function c65846101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846101.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,65846101)==0 end
	Duel.RegisterFlagEffect(tp,65846101,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65846101.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65846101.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end