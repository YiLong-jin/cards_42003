--大阿卡那 力量舞者
function c65840008.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65840008,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c65840008.damcon)
	e1:SetTarget(c65840008.damtg)
	e1:SetOperation(c65840008.damop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65840008,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c65840008.descon)
	e2:SetTarget(c65840008.destg)
	e2:SetOperation(c65840008.desop)
	c:RegisterEffect(e2)
end
function c65840008.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsFaceup() and tc:GetAttack()>0
end
function c65840008.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBattleTarget():GetAttack())
end
function c65840008.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		local tc=Duel.GetFirstTarget()
		if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
		if tc:GetAttack()<=0 then return end
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function c65840008.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c65840008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65840008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end