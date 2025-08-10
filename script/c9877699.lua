--黑骑士小队-苍灭
function c9877699.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9877699.matfilter,2,true)

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END) 
	e1:SetCondition(c9877699.rccon)
	e1:SetTarget(c9877699.rctg)
	e1:SetOperation(c9877699.rcop)
	c:RegisterEffect(e1)

	 local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877699,0))
	e11:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,9877699)
	e11:SetCondition(c9877699.condition)
	e11:SetTarget(c9877699.target)
	e11:SetOperation(c9877699.activate)
	c:RegisterEffect(e11)
end
function c9877699.matfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFusionSetCard(0x17ec)
end

function c9877699.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end 
function c9877699.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c9877699.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local atk=e:GetHandler():GetAttack()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,atk,REASON_EFFECT)
end



function c9877699.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER)  and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9877699.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,re:GetHandler():GetBaseAttack()+1000)
	end
end
function c9877699.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.BreakEffect() 
			Duel.Recover(tp,re:GetHandler():GetBaseAttack()+1000,REASON_EFFECT)
		end
	end
end