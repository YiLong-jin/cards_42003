--黑骑士小队-度灭
function c9877628.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9877628.matfilter,2,true)

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END) 
	e1:SetCondition(c9877628.rccon)
	e1:SetTarget(c9877628.rctg)
	e1:SetOperation(c9877628.rcop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877628,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_PAY_LPCOST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877628)
	e3:SetOperation(c9877628.desop)
	c:RegisterEffect(e3)
end



function c9877628.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFusionSetCard(0x17ec)
end
function c9877628.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end 
function c9877628.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c9877628.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local atk=e:GetHandler():GetAttack()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,atk,REASON_EFFECT)
end





function c9877628.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c) 
		  e1:SetType(EFFECT_TYPE_SINGLE) 
		  e1:SetCode(EFFECT_UPDATE_ATTACK)  
		  e1:SetRange(LOCATION_MZONE) 
		  e1:SetValue(1000) 
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		  c:RegisterEffect(e1) 
		if  Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(9877628,0)) then
			Duel.PayLPCost(tp,1000)
			local e11=Effect.CreateEffect(c) 
			e11:SetType(EFFECT_TYPE_SINGLE) 
			e11:SetCode(EFFECT_UPDATE_ATTACK)  
			e11:SetRange(LOCATION_MZONE) 
			e11:SetValue(1000) 
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e11) 
		end
end