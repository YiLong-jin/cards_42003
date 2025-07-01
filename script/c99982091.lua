--神谕昭现 最后之龙
local m=99982091
local cm=_G["c"..m]
function cm.initial_effect(c)
				--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.spcon1)
	e1:SetCountLimit(1,99982091+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99982091.target)
	e1:SetOperation(c99982091.activate)
--	c:RegisterEffect(e1)

				--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.spcon2)
	e2:SetCountLimit(1,99982091+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c99982091.target1)
	e2:SetOperation(c99982091.operation1)
	c:RegisterEffect(e2)


end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsAttack(1)
end
function c99982091.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c99982091.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99982091,0,0,0)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end











-----------------------------------------------------------------------------
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end
function c99982091.tgfilter(c)
	return c:IsAbleToHand() and not c:IsAttack(0)
end
function c99982091.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and not chkc:IsAttack(0) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c99982091.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c99982091.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c99982091.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99982091,0,0,0)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Damage(tp,atk,REASON_EFFECT)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end







