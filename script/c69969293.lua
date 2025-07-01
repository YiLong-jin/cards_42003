--交响曲·船长进行曲
function c69969293.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969293,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c69969293.spcost)
	e2:SetTarget(c69969293.sptg)
	e2:SetOperation(c69969293.spop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x69b))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969293,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,69969293)
	e3:SetTarget(c69969293.settg)
	e3:SetOperation(c69969293.setop)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c69969293.dtdcon2)
	c:RegisterEffect(e4)
end
function c69969293.dtdcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsPlayerAffectedByEffect(tp,69969252)
end 
function c69969293.costfilter(c)
	return c:IsSetCard(0x69b) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c69969293.costfilter2(c)
	return c:IsSetCard(0x69b) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL)
end
function c69969293.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	local dlc=LOCATION_HAND+LOCATION_ONFIELD
	if ft<1 then loc=LOCATION_MZONE end
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c69969293.costfilter,tp,loc,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c69969293.costfilter2,tp,dlc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c69969293.costfilter,tp,loc,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	local sg=Duel.SelectMatchingCard(tp,c69969293.costfilter2,tp,dlc,0,1,1,e:GetHandler())
	Duel.SendtoGrave(sg,REASON_COST)
end
function c69969293.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969293.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:SetMaterial(nil)
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
end
--3
function c69969293.setfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c69969293.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969293.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c69969293.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c69969293.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end