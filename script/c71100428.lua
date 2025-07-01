--死魂棋子仆从 白骸
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
end
s.Dead_souls_pawn=true --「死魂棋子」记述
function s.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_MACHINE)
end
function s.checkgroup(c)
	return c.Dead_souls_pawn and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsForbidden()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local sg=Duel.GetMatchingGroup(s.checkgroup,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #sg<1 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=sg:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	for tc in aux.Next(g) do 
		if Duel.Equip(tp,tc,c,false) then 
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
		end 
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function s.val(e,c)
	return c:GetEquipCount()*750
end