--恐虐魔域-黄铜堡垒
function c21400039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(LOCATION_FZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsRank(4,8) and c:IsAttribute(ATTRIBUTE_FIRE) end)
	e1:SetCondition(function(e) 
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and e:GetOwnerPlayer()==Duel.GetTurnPlayer() end)
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActivated() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) end)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,21400039) 
	e2:SetTarget(c21400039.lvtg)
	e2:SetOperation(c21400039.lvop)
	c:RegisterEffect(e2)
end
function c21400039.lvfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsLevel(8) and c:GetLevel()>0
end
function c21400039.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400039.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c21400039.lvop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21400039.lvfilter,tp,LOCATION_MZONE,0,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end


