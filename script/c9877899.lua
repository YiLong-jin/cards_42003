--水波玲奈异时间线觉醒
function c9877899.initial_effect(c)
	aux.AddCodeList(c,9877895,9877896,9877897)

	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1,99)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877899,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9877899)
	e1:SetCondition(c9877899.thcon)
	e1:SetTarget(c9877899.thtg)
	e1:SetOperation(c9877899.thop)
	c:RegisterEffect(e1)

	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9877899,1))
	e12:SetCategory(CATEGORY_DISABLE)
	e12:SetType(EFFECT_TYPE_QUICK_O) 
	e12:SetCode(EVENT_FREE_CHAIN) 
	e12:SetRange(LOCATION_MZONE) 
	e12:SetCountLimit(1,9877899)
	e12:SetCost(c9877899.negcost)
	e12:SetTarget(c9877899.negtg)
	e12:SetOperation(c9877899.negop)
	c:RegisterEffect(e12)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,9877899)
	e2:SetCost(c9877899.spcost)
	e2:SetTarget(c9877899.sptg)
	e2:SetOperation(c9877899.spop)
	c:RegisterEffect(e2)
end
function c9877899.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9877899.thfilter(c)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) ) and c:IsAbleToHand()
end
function c9877899.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877899.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877899.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877899.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c9877899.ctilter(c)
	return  c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c9877899.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877899.ctilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9877899.ctilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c9877899.negtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD) 
end
function c9877899.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if tc then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end


function c9877899.ctilter1(c)
	return  c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(8) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c9877899.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877899.ctilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9877899.ctilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c9877899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877899.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		c:RegisterEffect(e1,true)
	end
end