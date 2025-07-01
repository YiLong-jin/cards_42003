--刹那芳华 月下辉夜
function c10700765.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,nil,1)
	c:EnableReviveLimit() 
	--use baseattack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e0:SetCondition(c10700765.atkcon)
	e0:SetOperation(c10700765.atkop)
	c:RegisterEffect(e0) 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700765,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10700765)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c10700765.descon)
	e1:SetTarget(c10700765.destg)
	e1:SetOperation(c10700765.desop)
	c:RegisterEffect(e1) 
	--spirit return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c10700765.retreg)
	c:RegisterEffect(e4) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10700765,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(c10700765.thcon)
	e6:SetTarget(c10700765.thtg)
	e6:SetOperation(c10700765.thop)
	c:RegisterEffect(e6)
end
function c10700765.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
end
function c10700765.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(c:GetBaseAttack())
	c:RegisterEffect(e1)
end
function c10700765.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttack(0)
end
function c10700765.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:GetHandler():RegisterFlagEffect(10700765,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,2,Duel.GetTurnCount())
	else
		e:GetHandler():RegisterFlagEffect(10700765,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,1,0)
	end
end
function c10700765.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10700765.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c10700765.retcon)
	e1:SetTarget(c10700765.rettg)
	e1:SetOperation(c10700765.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c10700765.retcon2)
	e2:SetTarget(c10700765.rettg2)
	c:RegisterEffect(e2)
end
function c10700765.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700765.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700765.thfilter(c)
	return c:IsSetCard(0x7cc) and c:IsAbleToHand()
end
function c10700765.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,10700738) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700765.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700765,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end
function c10700765.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700765.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700765.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700765.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():GetFlagEffect(10700766)==0 end
	e:GetHandler():RegisterFlagEffect(10700766,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700765.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700765.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700765,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end