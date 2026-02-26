--爱之射箭
function c65842065.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_BATTLED+TIMING_BATTLE_STEP_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65842065.target)
	e1:SetOperation(c65842065.activate)
	c:RegisterEffect(e1)
end
c65842065.SetCard_ZJ_CZ=true
function c65842065.filter(c,tp)
	return c:IsFaceup() and (c.SetCard_ZJ_CZ or c:IsControler(1-tp))
end
function c65842065.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65842065.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65842065.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65842065.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c65842065.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)	
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.ChainAttack()
		end
	end
end