--交响曲·钟
function c69969252.initial_effect(c)
aux.AddLinkProcedure(c,c69969252.matfilter,1,1)
	c:EnableReviveLimit()
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(69969252)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c69969252.imcon)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2) 
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c69969252.imcon(e)
	return e:GetHandler():GetSequence()>4
end
function c69969252.matfilter(c)
	return c:IsLinkSetCard(0x69b) and not c:IsLinkType(TYPE_LINK)
end