--阿赖耶识
local m=92369010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
 --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
	e3:SetCondition(cm.spcon)
	c:RegisterEffect(e3)
  --atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
 --win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
end
function cm.spfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	return Duel.GetTurnCount()>=20
end

function cm.value(e,c)
	return Duel.GetMatchingGroupCount(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000
end

function cm.damop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetTurnCount()>=40 then 
   local WIN_REASON_alys=0x100
   Duel.Win(tp,WIN_REASON_alys)
   end
end








