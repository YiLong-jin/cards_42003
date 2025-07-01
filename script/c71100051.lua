--与V城的邂逅
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100051
local cm=_G["c"..m]
local code1=0x7d4 --宝物猎人
local code2=0x7d5 --银翼凶星
local code3=0x7d2 --V城
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(function(e,c) return cm.spcf(c) end)
	c:RegisterEffect(e2)
end
function cm.atktg(e,c)
	return c:IsRace(RACE_DRAGON) or cm.spcf(c)
end
function cm.spcf(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL)
end