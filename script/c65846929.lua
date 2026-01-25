--小幽幽子
function c65846929.initial_effect(c)
	aux.AddCodeList(c,65846916)
	aux.AddSynchroProcedure(c,c65846929.synfilter,aux.NonTuner(c65846929.synfilter),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65846929)
	e1:SetCondition(c65846929.stcon)
	e1:SetTarget(c65846929.sttg)
	e1:SetOperation(c65846929.stop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,65846929)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65846929.sptg)
	e2:SetOperation(c65846929.spop)
	c:RegisterEffect(e2)
end
function c65846929.synfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c65846929.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65846929.setfilter(c)
	return aux.IsCodeListed(c,65846916) and c:IsSSetable()
end
function c65846929.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846929.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c65846929.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846929.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g:GetFirst())~=0 then
		if g:GetFirst():IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(65846929,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		elseif g:GetFirst():IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(65846929,1))
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e2)
		end
	end
end
function c65846929.filter(c,e,tp)
	return aux.IsCodeListed(c,65846916) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65846929.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846929.filter(chkc,e,tp) and e:GetHandler()~=chkc end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65846929.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65846929.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65846929.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end