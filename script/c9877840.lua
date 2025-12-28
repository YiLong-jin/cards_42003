--叛逆特警-雪枭
function c9877840.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1) 
	c:EnableReviveLimit() 
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877840,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9877840)
	e1:SetTarget(c9877840.rectg)
	e1:SetOperation(c9877840.recop)
	c:RegisterEffect(e1)
	--tograve and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877840,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9877840)
	e2:SetCost(c9877840.tgcost)
	e2:SetTarget(c9877840.tgtg)
	e2:SetOperation(c9877840.tgop)
	c:RegisterEffect(e2)
end
function c9877840.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(2500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2500)
end
function c9877840.rspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec)
end 
function c9877840.recop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and Duel.GetTurnPlayer()==1-tp and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9877840.rspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9877840,2)) then 
		Duel.BreakEffect() 
		local sc=Duel.SelectMatchingCard(tp,c9877840.rspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end
function c9877840.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c9877840.tgfil(c,e,tp) 
	return c:IsAbleToGrave() and c:IsSetCard(0x17ec) and c:IsLevelAbove(1) and c:IsFaceup() and Duel.IsExistingMatchingCard(c9877840.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end 
function c9877840.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x17ec) and c:IsRace(RACE_MACHINE) and c:IsLevel(tc:GetLevel()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function c9877840.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	if chk==0 then return Duel.IsExistingTarget(c9877840.tgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9877840.tgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9877840.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c9877840.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst() 
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end


