--UGC量子武装mk2-梅莉
function c9877638.initial_effect(c)
	c:SetSPSummonOnce(9877638)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9877638.matfilter,4,99)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9877638.efilter)
	c:RegisterEffect(e3)


	 local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EFFECT_CANNOT_ACTIVATE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(1,1)
	e12:SetValue(c9877638.aclimit)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SSET)
	e13:SetRange(LOCATION_MZONE)
	e13:SetOperation(c9877638.aclimset)
	c:RegisterEffect(e13)
end
c9877638.SetCard_AY_ML=true
function c9877638.matfilter(c)
	return c:IsLinkSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end

function c9877638.efilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end


function c9877638.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:GetFlagEffect(9877638)>0
end
function c9877638.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local reset=tc:IsControler(tp) and RESET_OPPO_TURN or RESET_SELF_TURN
		tc:RegisterFlagEffect(9877638,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+reset,0,1)
		tc=eg:GetNext()
	end
end
