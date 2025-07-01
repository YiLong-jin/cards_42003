--Sp魔法 终焉的倒计时
local m=71000024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,3,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,3,REASON_COST)
	Duel.PayLPCost(tp,2000)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,20)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(cm.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,20)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,20)
	cm[c]=e1
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,m)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,21-ct)
	if ct==20 then
		Duel.Win(tp,0x11)
		c:ResetFlagEffect(1082946)
	end
end
