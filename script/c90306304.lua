--远古海洋 恐鳄
local s,id,o=GetID()
function c90306304.initial_effect(c)
	 --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,3)
   --effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(c90306304.settg)
	e1:SetOperation(c90306304.setop)
	c:RegisterEffect(e1)
 --to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90306304,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(2,id+o)
	e2:SetCost(c90306304.tgcost)
	e2:SetTarget(c90306304.settg)
	e2:SetOperation(c90306304.setop)
	c:RegisterEffect(e2)
   --special summon cost
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_SINGLE)
   -- e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e4:SetCode(EFFECT_SPSUMMON_COST)
 --   e4:SetCost(c90306304.spcost)
   -- e4:SetOperation(c90306304.spop)
	--c:RegisterEffect(e4)
end
function c90306304.setfilter(c)
	return c:IsSetCard(0x975) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c90306304.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90306304.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c90306304.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c90306304.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
end
end
function c90306304.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c90306304.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end
function c90306304.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90306304.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90306304.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
