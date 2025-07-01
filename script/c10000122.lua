--权杖使徒
function c10000122.initial_effect(c)
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
	e1:SetCondition(c10000122.hspcon) 
	e1:SetCountLimit(1,10000122+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)   
	--remove
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetCost(c10000122.rmcost)
	e2:SetTarget(c10000122.rmtg)
	e2:SetOperation(c10000122.rmop)
	c:RegisterEffect(e2)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(function(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end end) 
	e3:SetCondition(function(e)  
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10000120) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e3) 
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SUMMON) 
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(1,0)
	e3:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xafe2) end)
	e3:SetCondition(function(e)  
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10000120) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(1,0)
	e3:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xafe2) end)
	e3:SetCondition(function(e)  
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(10000120) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e3)
end
function c10000122.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(function(c) return c:GetSequence()<5 end,c:GetControler(),LOCATION_SZONE,0,nil)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end 
function c10000122.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c10000122.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
end 
function c10000122.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	end 
end 




