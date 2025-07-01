--寒霜稻草人
function c71100146.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,71100146+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c71100146.spcon)
	e1:SetOperation(c71100146.spop)
	c:RegisterEffect(e1)
   --activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c71100146.con)
	e2:SetValue(c71100146.aclimit)
	c:RegisterEffect(e2)
end
function c71100146.filter(c)
	return c:IsSetCard(0x7d9) and c:IsFaceup()
end
function c71100146.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71100146.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c71100146.spop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c71100146.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c71100146.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c71100146.con(e)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsSetCard(0x7d9) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c71100146.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER)
end