--英雄之证
local cm,m,t=GetID()  
function cm.initial_effect(c)
	aux.AddCodeList(c,71100206)
	aux.AddRitualProcEqual2(c,cm.rt,LOCATION_DECK,nil,cm.mt) 
end
function cm.rt(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DINOSAUR)
end
function cm.mt(c)
	return (c:IsSetCard(0x7db) or c:IsCode(71100206)) and c:IsLevelAbove(1)
end
