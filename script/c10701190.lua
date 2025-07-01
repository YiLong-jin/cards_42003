--进化龙·迷惑龙
function c10701190.initial_effect(c)
	--xyzlv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10701190.xyzlv)
	c:RegisterEffect(e1) 
	--lvup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701190,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10701190.lvcon)
	e2:SetTarget(c10701190.lvtg)
	e2:SetOperation(c10701190.lvop)
	c:RegisterEffect(e2) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701190,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10701190)
	e3:SetTarget(c10701190.thtg)
	e3:SetOperation(c10701190.thop)
	c:RegisterEffect(e3)  
end
function c10701190.xyzlv(e,c,rc)
	return 0x40000+e:GetHandler():GetLevel()
end
function c10701190.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st&SUMMON_VALUE_EVOLTILE>0 or (re and re:GetHandler():IsSetCard(0x10e) and re:GetHandler():IsType(TYPE_SPELL))
end
function c10701190.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c10701190.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10701190.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701190.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701190.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10701190.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if Duel.SelectOption(tp,aux.Stringid(10701190,2),aux.Stringid(10701190,3))==0 then
			e1:SetValue(1)
		else e1:SetValue(2) end
		tc:RegisterEffect(e1)
	end
end
function c10701190.thfilter(c)
	return c:IsSetCard(0x304e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10701190.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701190.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701190.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701190.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end