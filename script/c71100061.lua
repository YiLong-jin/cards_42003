--菌兽离歌·普罗米修斯
local m=71100061
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x7d1),aux.NonTuner(aux.FilterBoolFunction(Card.IsSetCard,0x7d1)),1,1)
	c:EnableReviveLimit()
   --cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
   --act limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100061,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.limcon)
	e2:SetOperation(cm.limop)
	c:RegisterEffect(e2)
end
function cm.cfilter1(c)
	return c:IsFaceup() and (c:IsSetCard(0x7d0) or c:IsSetCard(0x7d1))
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and ct>0 and Duel.GetMatchingGroupCount(cm.cfilter1,c:GetControler(),LOCATION_MZONE,0,nil)==ct
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
 local rc=re:GetHandler()
	return rc:IsOnField() and rc:IsLocation(LOCATION_MZONE) and not rc:IsType(TYPE_SYNCHRO)
end