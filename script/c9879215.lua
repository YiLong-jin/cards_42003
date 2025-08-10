--核心列车 叛逆特警
c9879215.hxlc=true
function c9879215.initial_effect(c)
	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND)
	e02:SetCountLimit(1,9879215)
	e02:SetCondition(c9879215.spcon)
	e02:SetTarget(c9879215.sptg)
	e02:SetOperation(c9879215.spop)
	c:RegisterEffect(e02)  


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879215,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1879215)
	e2:SetTarget(c9879215.destg)
	e2:SetOperation(c9879215.desop)
	c:RegisterEffect(e2)
end
function c9879215.f(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end
function c9879215.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9879215.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9879215.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879215.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879215.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c9879215.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) and (c:IsRankAbove(10) or c:IsLevel(10)))
end


function c9879215.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9879215.desop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879215.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
