--红雾传说 卡莉
function c10000140.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionCode,10000135),function(c) return c:IsLevelAbove(7) and c:IsFusionSetCard(0xa797) end,true)
	--change name
	--Edit by SZKTAS: Adding zone for change name (3rd argument of aux.EnableChagneCode)
	aux.EnableChangeCode(c,10000135,LOCATION_MZONE+LOCATION_GRAVE):SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,re,rp) 
	return re:IsActiveType(TYPE_MONSTER) end)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	--Edit by SZKTAS: Wrong category: CATEGORY_DAMAGE should be (CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10000140.destg)
	e2:SetOperation(c10000140.desop)
	c:RegisterEffect(e2)
	--ATK Up
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetOperation(c10000140.atkop)
	c:RegisterEffect(e3)
end
function c10000140.desfil(c)
	return c:IsFaceup() and (c:IsAttackBelow(2200) or c:IsDefenseBelow(2200))
end
function c10000140.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10000140.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10000140.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end
function c10000140.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c10000140.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		-- Edit by SZKTAS: Polyfilling missing operation (Add atk/def)
		local descount = Duel.Destroy(g,REASON_EFFECT)
		if c:IsRelateToEffect(e) and c:IsFaceup() and descount > 0 then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(descount * 400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2 = e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end
function c10000140.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		-- Edit by SZKTAS: adding RESET_DISABLE, allowing atk reset at disable
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		-- Edit by SZKTAS: Prevent re-definition of e1, reduce redenent definition using Effect.Clone
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end