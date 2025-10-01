--黑骑士小队-湮灭·天龙座
function c9878514.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x17ec),10,2)
	c:EnableReviveLimit() 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_NEGATE+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9878514)
	e2:SetCondition(c9878514.discon)
	e2:SetCost(c9878514.discost)
	e2:SetTarget(c9878514.distg)
	e2:SetOperation(c9878514.disop)
	c:RegisterEffect(e2)
end
function c9878514.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_MACHINE)
end
function c9878514.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c9878514.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9878514.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c9878514.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xdaaf) end,tp,LOCATION_SZONE,0,1,nil) and Duel.IsChainNegatable(ev) and Duel.CheckLPCost(tp,3000) and Duel.SelectYesNo(tp,aux.Stringid(9878514,0)) then 
		Duel.PayLPCost(tp,3000)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
			Duel.Destroy(eg,REASON_EFFECT) 
		end 
	end
end





