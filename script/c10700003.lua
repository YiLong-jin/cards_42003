--强化妹妹 艾薇儿
function c10700003.initial_effect(c)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700003,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c10700003.atkcon)
	e3:SetCost(c10700003.atkcost)
	e3:SetTarget(c10700003.atktg)
	e3:SetOperation(c10700003.atkop)
	c:RegisterEffect(e3)	
	--synchro effect
	local e2=aux.GrandsCychroTargetCheckEffect(c)
end
function c10700003.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end
	return a
end
function c10700003.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.CheckLPCost(tp,2000) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD) 
	Duel.PayLPCost(tp,2000)
	e:GetHandler():RegisterFlagEffect(10700003,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c10700003.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	if not a:IsControler(tp) then
		a=Duel.GetAttackTarget()
	end
	Duel.SetTargetCard(a)
end
function c10700003.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	if tc:IsRelateToBattle() and tc:IsControler(tp) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(3000)
	tc:RegisterEffect(e1)
	end
end