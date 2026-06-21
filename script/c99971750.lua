--创造物弹射器
function c99971750.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99971750)
	e1:SetTarget(c99971750.target)
	e1:SetOperation(c99971750.activate)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99971750,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c99971750.spcost)
	e2:SetTarget(c99971750.sptg)
	e2:SetOperation(c99971750.spop)
	c:RegisterEffect(e2)
end
function c99971750.thfilter2(c,tp)
	return c:IsCode(99971660) and c:IsAbleToHand() and c:IsFaceupEx() and Duel.IsExistingMatchingCard(c99971750.thfilter2a,tp,LOCATION_DECK,0,1,nil)
end
function c99971750.thfilter2a(c)
	return c:IsCode(99971670) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971750.thfilter2t(c)
	return c:IsCode(99971660) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c99971750.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971750.thfilter2,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99971750.fselect(g)
	return g:FilterCount(c99971750.thfilter2t,nil)==1
end
function c99971750.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(function(c) return c:IsCode(99971670) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsCode(99971660) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		local g=Group.__add(g1,g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c99971750.fselect,false,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c99971750.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99971750.filter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x67f) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c99971750.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971750.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99971750.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99971750.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local tc=g:GetFirst()
		tc:RegisterFlagEffect(99971750,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c99971750.rmcon)
		e1:SetOperation(c99971750.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c99971750.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(99971750)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c99971750.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end