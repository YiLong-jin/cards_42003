--辉光之宣告者
function c10701258.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunRep(c,c10701258.ffilter,2,true)
	--spsum condition
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701258,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c10701258.sptg)
	e1:SetOperation(c10701258.spop)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701258,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10701258.thcon)
	e2:SetTarget(c10701258.thtg)
	e2:SetOperation(c10701258.thop)
	c:RegisterEffect(e2)   
end
function c10701258.matchfilter(c,attr,race)
	return c:IsFusionAttribute(attr) and c:IsRace(race)
end
function c10701258.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(c10701258.matchfilter,#sg-1,c,c:GetFusionAttribute(),c:GetRace()))
end
function c10701258.spfilter(c,e,tp)
	return ((c:IsType(TYPE_FUSION) and c:CheckFusionMaterial() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)) 
		or (c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)) 
		or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL))
		or (c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)))
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c10701258.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701258.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701258.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,c10701258.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if sg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsCode,nil,sg:GetFirst():GetCode())
		if tg:GetCount()>0 then
			if tc:IsType(TYPE_FUSION) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then
				 tc:SetMaterial(nil)
				 if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				   tc:CompleteProcedure()
				 end
			elseif tc:IsType(TYPE_SYNCHRO) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then
				 tc:SetMaterial(nil)
				 if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
				   tc:CompleteProcedure()
				 end
			elseif tc:IsType(TYPE_LINK) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then
				 tc:SetMaterial(nil)
				 if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
				   tc:CompleteProcedure()
				 end
			elseif tc:IsType(TYPE_XYZ) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then
				 tc:SetMaterial(nil)
				 if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
				   tc:CompleteProcedure()
				   Duel.Overlay(tc,Group.FromCards(c))
				 end
			end
		end
		Duel.ShuffleExtra(tp)
		Duel.ShuffleExtra(1-tp)
	end
end
function c10701258.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re and re:IsActivated()) then return false end
	return e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_COST) 
end
function c10701258.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c10701258.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c10701258.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701258.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_SPELL)<2 and g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<2
		and g:GetClassCount(Card.GetLocation)==#g
end
function c10701258.thop(e,tp,eg,ep,ev,re,r,rp)
	local mft,sft=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(tp,LOCATION_SZONE)
	if mft<=0 and sft<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701258.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,c10701258.gcheck,false,1,2)
	if tg:GetCount() then 
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end