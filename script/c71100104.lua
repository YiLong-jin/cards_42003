--死灵舞者·队长
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		Duel.LoadScript("c71000111.lua")
	end
end
local m=71100104
local cm=_G["c"..m]
local code1=0x7d7 --死者
local code2=0x7d8 --死灵舞者
local code3=0x17d7 --行动力指示物
function cm.initial_effect(c)
	c:EnableCounterPermit(code3)
	--counter
	local e1=bm.b.ce(c,nil,CATEGORY_COUNTER,EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS,EVENT_SUMMON_SUCCESS,nil,nil,bm.b.con,bm.b.cost,bm.b.tar,function(e,tp,eg,ep,ev,re,r,rp) e:GetHandler():AddCounter(code3,7) end,nil)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect time
	local e3=bm.b.ce(c,nil,nil,EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O,EVENT_FREE_CHAIN,{1,m},mz,bm.b.con,bm.b.cost,cm.tar,cm.op,nil)
	c:RegisterEffect(e3)
	--attackup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(function(e,sc) return sc:GetCounter(code3)*200 end)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
function cm.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=bm.c.get(e,tp,bm.c.cpos,mz,0,e:GetHandler(),code2):GetCount()
	if chk==0 then return num>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(c,EVENT_CUSTOM+71100104,e,0,tp,tp,0)
end