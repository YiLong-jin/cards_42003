--神之梦——祓除迷茫之剑
function c22352135.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22352135+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22352135.target)
	e1:SetOperation(c22352135.activate)
	c:RegisterEffect(e1)
end
function c22352135.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc29) and c:IsType(TYPE_LINK) and c:IsLinkAbove(2)
end
function c22352135.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22352135.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22352135.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22352135.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22352135.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c22352135.atkval)
		tc:RegisterEffect(e1)
	end
end

function c22352135.atkval(e,c)
	return Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetOriginalAttribute)*500
end