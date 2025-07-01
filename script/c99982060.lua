--神谕昭现 灵魂猎手
local m=99982060
local cm=_G["c"..m]
function cm.initial_effect(c)
	
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCondition(cm.spcon1)
	e1:SetOperation(c99982060.activate16)
	c:RegisterEffect(e1)
	

	
	
end

function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,99982060)==0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end
function cm.activate16(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99982060.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
--	e1:SetLabel(e:GetLabel())
	e1:SetTarget(c99982060.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c99982060.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(700)
	Duel.RegisterEffect(e2,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(c99982060.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(700)
	Duel.RegisterEffect(e2,tp)--[[
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTarget(c99982060.tg2)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(c99982060.ifilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)]]
end
function c99982060.tg(e,c)
	return c:IsSetCard(0x66d) and c:IsFaceup()
end
function c99982060.atkup(e,c,tp)
	local g=Duel.GetMatchingGroup(c99982060.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return aux.GetAttributeCount(g)*100
end
function c99982060.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d)
end


