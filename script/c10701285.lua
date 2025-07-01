--虹之桥梁 碧佛洛斯特
function c10701285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701285,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+10701285)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c10701285.setcon)
	e2:SetTarget(c10701285.settg)
	e2:SetOperation(c10701285.setop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(10701285)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(c10701285.changefilter))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	if not c10701285.global_check then
		c10701285.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetCondition(c10701285.regcon)
		ge1:SetOperation(c10701285.regop)
		Duel.RegisterEffect(ge1,0)
		c10701285[0]=Card.RegisterEffect
		Card.RegisterEffect=function(v1,v2,...)
			--变成对方回合也能用的效果
			if v2:GetType()&EFFECT_TYPE_IGNITION~=0 then 
				local con_c=v2:GetCondition()
				local cost_c=v2:GetCost()
				v2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if e:GetHandler():IsHasEffect(10701285) then return false end
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				local se=v2:Clone()
				se:SetType(EFFECT_TYPE_QUICK_O)
				se:SetCode(EVENT_FREE_CHAIN)
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if not e:GetHandler():IsHasEffect(10701285) then return false end
					--if Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2 then return false end 
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				v2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==1 then se:UseCountLimit(tp,1) end 
					return not cost_c or cost_c(e,tp,eg,ep,ev,re,r,rp,chk)
				end)
				se:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==1 then v2:UseCountLimit(tp,1) end 
					return not cost_c or cost_c(e,tp,eg,ep,ev,re,r,rp,chk)
				end)
				c10701285[0](v1,se,...)
			elseif v2:GetType()&EFFECT_TYPE_QUICK_O~=0 and v1:IsOriginalCodeRule(67098114) then 
				local con_c=v2:GetCondition()
				local cost_c=v2:GetCost()
				v2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if e:GetHandler():IsHasEffect(10701285) then return false end
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				local se=v2:Clone()
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if not e:GetHandler():IsHasEffect(10701285) then return false end
					return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
				end)
				v2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==1 then se:UseCountLimit(tp,1) end 
					return not cost_c or cost_c(e,tp,eg,ep,ev,re,r,rp,chk)
				end)
				se:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==1 then v2:UseCountLimit(tp,1) end 
					return not cost_c or cost_c(e,tp,eg,ep,ev,re,r,rp,chk)
				end)
				c10701285[0](v1,se,...)
			end
			return c10701285[0](v1,v2,...)
		end
	end 
end
function c10701285.changefilter(c)
	return c:IsOriginalSetCard(0x4b)
end
function c10701285.regcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x4b) and loc&LOCATION_MZONE~=0 
end
function c10701285.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(re:GetHandler(),EVENT_CUSTOM+10701285,re,r,rp,ep,ev)
end
function c10701285.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function c10701285.filter(c)
	return ((c:IsSetCard(0x5042) and c:IsType(TYPE_SPELL+TYPE_TRAP)) 
	   or c:IsCode(16308000,28643791,88069166,89914395,91148083,14464864,50433147)) and c:IsSSetable() 
end
function c10701285.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10701285.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10701285.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701285.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end