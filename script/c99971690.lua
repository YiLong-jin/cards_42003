--古老创造物
function c99971690.initial_effect(c)
	aux.EnableChangeCode(c,99971660,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99971690,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,99971690+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c99971690.spcon)
	e1:SetValue(c99971690.spval)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99971690,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c99971690.thtg)
	e2:SetOperation(c99971690.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c99971690.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c99971690.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c99971690.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x67f) and c:IsAbleToHand()
end
function c99971690.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971690.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,99971690)==0 end
	Duel.RegisterFlagEffect(tp,99971690,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99971690.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99971690.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end