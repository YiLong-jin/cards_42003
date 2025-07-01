--龙族收容之壶
local m=64000042
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Prevent Activation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(c64000042.distg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(c64000042.aclimit)
	c:RegisterEffect(e3)
	
end

function c64000042.aclimit(e,re,tp)
	return (re:GetHandler():IsRace(RACE_DRAGON) or re:GetHandler():IsRace(RACE_DINOSAUR) or re:GetHandler():IsRace(RACE_SEASERPENT) or re:GetHandler():IsRace(RACE_WYRM)) and re:IsActiveType(TYPE_MONSTER)
end
function c64000042.distg(e,c)
	return (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_DINOSAUR) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_WYRM)) and c:IsType(TYPE_EFFECT)
end