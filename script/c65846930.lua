--LIVE 妖梦
function c65846930.initial_effect(c)
	aux.AddCodeList(c,65846916)
	--aux.AddSynchroProcedure(c,c65846930.synfilter1,aux.NonTuner(c65846930.synfilter2),1)
	aux.AddSynchroMixProcedure(c,c65846930.synfilter1,nil,nil,c65846930.synfilter2,1,99)
	c:EnableReviveLimit()	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846930,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_GRAVE_SPSUMMON+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65846930)
	e1:SetCondition(c65846930.discon)
	e1:SetTarget(c65846930.distg)
	e1:SetOperation(c65846930.disop)
	c:RegisterEffect(e1)
end
function c65846930.synfilter1(c,syncard)
	return c:IsType(TYPE_SYNCHRO) and c:IsTuner(syncard)
end
function c65846930.synfilter2(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c65846930.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and rp~=tp 
end
function c65846930.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c65846930.filter(c,e,tp,ft)
	return aux.IsCodeListed(c,65846916) and c:IsFaceup() and not c:IsCode(65846930)
		and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c65846930.disop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local chkem=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	local g=Duel.GetMatchingGroup(c65846930.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,ft)
	if 	Duel.NegateEffect(ev) and chkem and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(65846930,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if Duel.SendtoGrave(rg,REASON_EFFECT)==0 then return end
		local sg=Duel.GetMatchingGroup(c65846930.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		local opt=0
		if not tc:IsAbleToHand() then
			opt=1
		elseif not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 then
			opt=0
		else
			opt=Duel.SelectOption(tp,1190,1152)
		end
		if opt==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
