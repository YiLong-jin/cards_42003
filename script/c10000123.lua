--长枪使徒
function c10000123.initial_effect(c)
	--cannot be material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL) 
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10000123.hspcon) 
	e1:SetCountLimit(1,10000123+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)   
	--negate
	--Damage 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(c10000123.damcon) 
	e3:SetOperation(c10000123.damop)
	c:RegisterEffect(e3) 
	--bp disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c10000123.xchkcon)
	e3:SetOperation(c10000123.fdisop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(c10000123.fdistg)
	e5:SetCondition(c10000123.xchkcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_DISABLE_EFFECT)
	e6:SetValue(RESET_TURN_SET)
	c:RegisterEffect(e6)
end
function c10000123.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end  
function c10000123.xchkcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10000120) end,tp,LOCATION_MZONE,0,1,nil) 
end
function c10000123.damcon(e,tp,eg,ep,ev,re,r,rp)  
	local a=Duel.GetAttacker() 
	return c10000123.xchkcon(e,tp,eg,ep,ev,re,r,rp) and a:IsControler(tp)
end 
function c10000123.damop(e,tp,eg,ep,ev,re,r,rp)
	if c10000123.damcon(e,tp,eg,ep,ev,re,r,rp) then 
		Duel.Hint(HINT_CARD,0,10000123) 
		Duel.Damage(1-tp,1000,REASON_EFFECT) 
	end 
end 
function c10000123.fdisop(e,tp,eg,ep,ev,re,r,rp)
	Duel.AdjustInstantly(e:GetHandler())
end
function c10000123.disfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xafe2) and c:IsControler(tp) 
end
function c10000123.fdistg(e,c)
	local fid=e:GetHandler():GetFieldID()
	for _,flag in ipairs({c:GetFlagEffectLabel(10000123)}) do 
		if flag==fid then return true end
	end
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and bc and c10000123.disfilter(bc,e:GetHandlerPlayer()) then
		c:RegisterFlagEffect(10000123,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		return true 
	end
	return false
end 








