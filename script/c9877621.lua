--黑骑士小队-讨灭
function c9877621.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9877621.matfilter,2,true)

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END) 
	e1:SetCondition(c9877621.rccon)
	e1:SetTarget(c9877621.rctg)
	e1:SetOperation(c9877621.rcop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877621)
	e3:SetCost(c9877621.cost1)
	e3:SetCondition(c9877621.spcon1)
	e3:SetOperation(c9877621.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877621.spcon2)
	c:RegisterEffect(e4)
	
end
function c9877621.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877621.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end


function c9877621.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFusionSetCard(0x17ec)
end

function c9877621.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end 
function c9877621.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c9877621.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local atk=e:GetHandler():GetAttack()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,atk,REASON_EFFECT)
end



function c9877621.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9877621.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	 if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(9877621,0)) then
		 Duel.PayLPCost(tp,1000)
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_SINGLE) 
		e2:SetCode(EFFECT_UPDATE_ATTACK)  
		e2:SetRange(LOCATION_MZONE) 
		e2:SetValue(1000) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e2) 
	end
end
