--瞬间、心灵重叠
local m = 71100073
local cm = _G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--attack select
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x7d4) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil,tp,c)
end
function cm.filter2(c,tp,oc)
	local atk=c:GetAttack()+oc:GetAttack()+c:GetDefense()+oc:GetDefense()
	return c:IsSetCard(0x7d4) and c:IsType(TYPE_MONSTER) and c:GetRace()~=oc:GetRace() and Duel.IsExistingMatchingCard(cm.filter3,tp,0,LOCATION_MZONE,1,nil,atk)
end
function cm.filter3(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,0,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if #g1<1 then return end
	local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,1,nil,tp,g1:GetFirst())
	g2:Merge(g1)
	Duel.ConfirmCards(1-tp,g2)
	local atk=g2:GetSum(Card.GetAttack)+g2:GetSum(Card.GetDefense)
	local dg=Duel.GetMatchingGroup(cm.filter3,tp,0,LOCATION_MZONE,nil,atk)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then 
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
function cm.atkf(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_DRAGON)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.atkf(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.atkf,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.atkf,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end