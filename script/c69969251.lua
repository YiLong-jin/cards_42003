--交响曲·四季·冬
function c69969251.initial_effect(c)
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969251,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e1:SetCountLimit(1,69969251+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c69969251.sprcon)
	e1:SetOperation(c69969251.sprop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969251,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,69969246)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c69969251.nacost)
	e2:SetCondition(c69969251.condition2)
	e2:SetTarget(c69969251.settg)
	e2:SetOperation(c69969251.setop)
	c:RegisterEffect(e2)   
end
function c69969251.cfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0
end
function c69969251.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c69969251.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,Card.IsAbleToGraveAsCost)
end
function c69969251.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c69969251.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp,Card.IsAbleToGraveAsCost)
	Duel.SendtoGrave(g,REASON_COST)
end
--2
function c69969251.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c69969251.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x169b,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x169b,2,REASON_COST)
end
function c69969251.filter(c)
	return ((c:IsSetCard(0x669b) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (c:IsSetCard(0x69b) and c:IsType(TYPE_TRAP))) and c:IsSSetable()
end
function c69969251.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969251.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c69969251.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c69969251.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end






