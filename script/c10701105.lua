--高速魔法－速击之翼
function c10701105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c10701105.ctop)
	c:RegisterEffect(e2) 
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701105,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10701105.atkcon)
	e3:SetCondition(c10701105.atkcon2)
	e3:SetTarget(c10701105.atktg)
	e3:SetOperation(c10701105.atkop)
	c:RegisterEffect(e3)   
end
function c10701105.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c10701105.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10701105.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x104d,1)
	end
end
function c10701105.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end
	return a 
end
function c10701105.atkcon2(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x104d)>=3
end
function c10701105.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	if not a:IsControler(tp) then
		a=Duel.GetAttackTarget()
	end
	Duel.SetTargetCard(a)
end
function c10701105.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	local ct=Duel.GetCounter(c:GetControler(),1,0,0x104d)
	if tc:IsRelateToBattle() and tc:IsControler(tp) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ct*100)
	tc:RegisterEffect(e1)
	end
end