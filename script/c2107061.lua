--腹蛇蛇
local m=2107061
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Duel.MoveToField
		Duel.MoveToField=function(tc,...)
			if tc:IsHasEffect(m) then
				return false
			else
				return cm[0](tc,...)
			end
		end
		cm[1]=Duel.ReturnToField
		Duel.ReturnToField=function(tc,...)
			if tc:IsHasEffect(m) then
				return false
			else
				return cm[1](tc,...)
			end
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)

end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(m)
	e1:SetTargetRange(LOCATION_REMOVED,LOCATION_REMOVED)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_REMOVED))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--to ga
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	Duel.RegisterEffect(e4,tp)
	--to ha 
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	Duel.RegisterEffect(e5,tp)
	--sp 
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e6,tp)
end












