--藤原妹红
function c10000114.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--race
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_ADD_RACE)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e1:SetRange(0xff) 
	e1:SetValue(RACE_ZOMBIE) 
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1) 
	e2:SetLabel(2)
	e2:SetCondition(c10000114.xxcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3) 
	--Destroy
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1) 
	e3:SetLabel(3)
	e3:SetCondition(c10000114.xxcon)
	e3:SetTarget(c10000114.destg) 
	e3:SetOperation(c10000114.desop) 
	c:RegisterEffect(e3) 
	--immuse 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
	e4:SetLabel(4)
	e4:SetCondition(c10000114.xxcon)
	c:RegisterEffect(e4) 
	--negate
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10000114)
	e5:SetCondition(c10000114.discon)
	e5:SetTarget(c10000114.distg)
	e5:SetOperation(c10000114.disop)
	c:RegisterEffect(e5)
end
function c10000114.xxcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>=e:GetLabel()  
end 
function c10000114.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end 
	local g1=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) end,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil) 
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end 
function c10000114.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT)   
	end 
end 
function c10000114.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) end,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c10000114.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10000114.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end












