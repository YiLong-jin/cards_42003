--诡异神器 地平线·冷匣
function c9990750.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,c9990750.mfilter,nil,2,2)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9990750)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetOperation(c9990750.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9990750+1)
	e2:SetCost(c9990750.cost)
	e2:SetTarget(c9990750.target)
	e2:SetOperation(c9990750.activate)
	c:RegisterEffect(e2)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(function(e) return e:GetHandler():IsAttackPos() end)
	e5:SetCost(c9990750.atkcost)
	e5:SetOperation(c9990750.atkop)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(function(e) return e:GetHandler():IsDefensePos() end)
	e6:SetTarget(c9990750.edtg)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
end
c9990750.pendulum_level=8
function c9990750.mfilter(c,xyzc)
	return c:IsSetCard(0x671) and c:IsSynchroType(TYPE_SYNCHRO)
end
function c9990750.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function c9990750.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(c9990750.efilter)
	e1:SetTarget(function(e,c)
		if c:IsFacedown() then return false end
		return c==e:GetHandler() or c:IsSetCard(0x671)
	end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c9990750.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end

function c9990750.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9990750.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c9990750.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9990750.filter,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c9990750.filter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c9990750.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end

function c9990750.edtg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x671)
end
function c9990750.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return c:GetFlagEffect(9990750)==0 and bc  end
	c:RegisterFlagEffect(9990750,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1) 
end
function c9990750.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1500)
		c:RegisterEffect(e1)
	end
end
