--式神·贵人

local s,id,o=GetID()


function s.initial_effect(c)
	-- 特殊召唤限制：只能通过「五行之巅·久远」的效果特殊召唤
	c:EnableReviveLimit()
	
	-- 召唤条件
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	

	
	-- 效果②：不会被效果破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
		-- ATK increase effect 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)

end
-- ATK increase calculation (修正版：排除里侧表示怪兽)
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(function(sc)return sc:IsFaceup() and sc:IsRace(RACE_SPELLCASTER) end,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*1000
end
-- 特殊召唤限制函数
function s.splimit(e,se,sp,st)
	-- 只能通过「五行之巅·久远」的效果特殊召唤
	return se and se:GetHandler():IsCode(99971100)
end

