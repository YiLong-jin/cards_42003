--叛逆特警-莉莉亚
function c9877849.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1) 
	c:EnableReviveLimit() 
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877849,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9877849)
	e1:SetTarget(c9877849.rectg)
	e1:SetOperation(c9877849.recop)
	c:RegisterEffect(e1)
	--xyz 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877840,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9877849)
	e2:SetCost(c9877849.ovcost)
	e2:SetTarget(c9877849.ovtg)
	e2:SetOperation(c9877849.ovop)
	c:RegisterEffect(e2)
end
function c9877849.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(2500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2500)
end
function c9877849.srfilter(c)
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end 
function c9877849.recop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and Duel.GetTurnPlayer()==1-tp and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9877849.srfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877849,2)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,c9877849.srfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end 
end
function c9877849.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9877849.ovfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0x17ec) and c:IsRace(RACE_MACHINE) and Duel.IsExistingMatchingCard(c9877849.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end  
function c9877849.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsRank(tc:GetLevel()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9877849.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c9877849.ovfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c9877849.ovfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9877849.ovop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c9877849.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst() 
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure() 
	end
end 

