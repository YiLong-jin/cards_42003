--神谕昭现 最后之龙·蛮横之金龙
local m=99982090
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
	e1:SetCountLimit(1,99982090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99982090.target)
	e1:SetOperation(c99982090.activate)
	c:RegisterEffect(e1)

				--Activate
--	local e2=Effect.CreateEffect(c)
--	e2:SetDescription(aux.Stringid(m,1))
--	e2:SetType(EFFECT_TYPE_ACTIVATE)
--	e2:SetCategory(CATEGORY_ATKCHANGE)
--	e2:SetCode(EVENT_FREE_CHAIN)
--	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
--	e2:SetCondition(cm.spcon2)
--	e2:SetCountLimit(1,99982090+EFFECT_COUNT_CODE_OATH)
--	e2:SetTarget(c99982090.target1)
--	e2:SetOperation(c99982090.operation1)
--	c:RegisterEffect(e2)


end









-----------------------------------------------------------------------------
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end
function c99982090.tgfilter(c)
	return c:IsAbleToHand() and not c:IsAttack(0)
end
function c99982090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and not chkc:IsAttack(0) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c99982090.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99982090,0,0,0)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Damage(tp,atk,REASON_EFFECT)
		Duel.GetControl(tc,tp)
	end
end



