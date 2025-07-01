--光河界龙 莱普纳
function c33330167.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c33330167.MatFilter,3,3)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c33330167.efilter1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c33330167.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c33330167.splimit3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c33330167.sumlimit4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e5)
--
end
--
function c33330167.MatFilter(c)
	return c:IsLinkType(TYPE_XYZ) and c:IsLinkRace(RACE_DRAGON)
end
--
function c33330167.efilter1(e,te)
	return not (te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsRace(RACE_DRAGON))
end
--
function c33330167.val2(e,c)
	return not c:IsRace(RACE_DRAGON)
end
--
function c33330167.splimit3(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and not c:IsRace(RACE_DRAGON)
end
--
function c33330167.sumlimit4(e,c,tp,sumtp)
	return bit.band(sumtp,SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and not c:IsRace(RACE_DRAGON)
end
--