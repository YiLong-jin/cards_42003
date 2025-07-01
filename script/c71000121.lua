--虚漠龙
local m=71000121
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.mf,7,63,true)
	--level change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
end
function cm.mf(c)
	return c:IsRace(RACE_THUNDER) and not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND))
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local bc1,bc2=Duel.GetBattleMonster(tp)
	return bc1 and bc2 and bc1==e:GetHandler() and bc2:IsFaceup() and bc2:IsLevelAbove(1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c,bc=Duel.GetBattleMonster(tp)
	if c and c:IsRelateToEffect(e) and bc then
		ct={}
		if not bc:IsLevel(1) then table.insert(ct,1) end
		if not bc:IsLevel(7) then table.insert(ct,7) end
		Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
		local lv=Duel.AnnounceNumber(tp,table.unpack(ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		bc:RegisterEffect(e1)
	end
end
function cm.vfilter(c)
	return c:IsRace(RACE_THUNDER)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.vfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end