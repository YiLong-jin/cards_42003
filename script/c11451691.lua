--牛头巨象
local cm,m=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,5053103,49888191,true,true)
end