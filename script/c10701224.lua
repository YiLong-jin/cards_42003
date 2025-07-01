--孽驱君主 朱斯提亚
function c10701224.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,10700666)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0) 
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10701224.slcon)
	e1:SetValue(8)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_PZONE,0)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701224,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10701224.descon)
	e4:SetCost(c10701224.descost)
	e4:SetTarget(c10701224.destg)
	e4:SetOperation(c10701224.desop)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701224,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c10701224.atkcon)
	e5:SetOperation(c10701224.atkop)
	c:RegisterEffect(e5) 
	if not c10701224.global_check then
		c10701224.global_check=true
		c10701224[0]=0
		c10701224[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c10701224.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c10701224.clearop)
		Duel.RegisterEffect(ge2,0)
	end 
end
function c10701224.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_RITUAL) then
			local p=tc:GetSummonPlayer()
			c10701224[p]=c10701224[p]+1
		end
		tc=eg:GetNext()
	end
end
function c10701224.clearop(e,tp,eg,ep,ev,re,r,rp)
	c10701224[0]=0
	c10701224[1]=0
end
function c10701224.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return c10701224[tp]>0
end
function c10701224.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(c10701224[tp]*800)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c10701224.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetOriginalLeftScale()==6
end
function c10701224.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10701224.scfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c10701224.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)&RACE_FIEND==0
end
function c10701224.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsReleasable()
end
function c10701224.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c10701224.costfilter,1,REASON_COST,true,nil,TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroupEx(tp,c10701224.costfilter,1,1,REASON_COST,true,nil,TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end
function c10701224.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and not rc:IsRace(RACE_FIEND) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c10701224.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then Duel.Destroy(rc,REASON_EFFECT) end
end