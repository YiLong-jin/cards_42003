--彩虹 晴
function c65846103.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846103+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c65846103.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65846103.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65846103,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,65846103)
	e3:SetCondition(c65846103.sccon)
	e3:SetTarget(c65846103.sctg)
	e3:SetOperation(c65846103.scop)
	c:RegisterEffect(e3)
end
c65846103.SetCard_ZJ_CH=true
function c65846103.thfilter(c)
	return c.SetCard_ZJ_CH and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65846103.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c65846103.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65846103,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--[[function c65846103.refilter(c,tp)
	return c:IsRace(0x4) and c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(c65846103.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function c65846103.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c65846103.refilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(65846103,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c65846103.refilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		if Duel.Release(g,REASON_EFFECT)==0 then return end				
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846103.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end]]
function c65846103.confilter(c)
	return c:IsFaceup() and c:IsRace(0x4) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c65846103.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65846103.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c65846103.scconfilter(c,tp)
	return c:IsFaceup()
end
function c65846103.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65846103.scconfilter,1,nil,tp)
end
function c65846103.mfilter(c)
	return c:IsRace(0x4) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65846103.syncheck(g,tp,syncard)
	return g:IsExists(c65846103.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c65846103.scfilter(c,tp,mg)
	return mg:CheckSubGroup(c65846103.syncheck,2,#mg,tp,c)
end
function c65846103.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		return Duel.IsExistingMatchingCard(c65846103.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg) and Duel.GetFlagEffect(tp,65846103)<2 end
	Duel.RegisterFlagEffect(tp,65846103,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65846103.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(c65846103.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,c65846103.syncheck,false,2,#mg,tp,sc)
		Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
	end
end