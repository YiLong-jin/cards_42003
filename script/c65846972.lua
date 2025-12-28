--小阿卡那的星币 白天鹅
function c65846972.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846972,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,65846973)
	e1:SetTarget(c65846972.thtg)
	e1:SetOperation(c65846972.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846972,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,65846972+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c65846972.spcon)
	c:RegisterEffect(e2)	
end
function c65846972.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33ef)
end
function c65846972.spcon(e,c)
	if c==nil then return true end
	return (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0 or Duel.GetMatchingGroupCount(c65846972.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)>0)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c65846972.filter(c)
	return c:IsSetCard(0x33ef) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c65846972.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846972.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c65846972.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c65846972.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
