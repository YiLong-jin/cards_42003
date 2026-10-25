--无法承受的代价
function c9878513.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9878513+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c9878513.actg)
	e1:SetOperation(c9878513.acop)
	c:RegisterEffect(e1)   
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1878513)  
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9878513.sptg)
	e2:SetOperation(c9878513.spop)
	c:RegisterEffect(e2) 
end
function c9878513.gvfilter(c)
	return c:IsFaceup() and c:IsCode(9877918) and c:IsAbleToGrave() 
end
function c9878513.espfil(c,e,tp)
	return c:IsCode(9878512) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(1-tp,tp,nil,c)>0  
end
function c9878513.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9878513.gvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878513.gvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c9878513.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9878513.gvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end
function c9878513.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c9878513.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c9878513.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP) 
				sc:CompleteProcedure()
			end
		end
	end
end 
function c9878513.spfilter(c,e,tp)
	return c:IsCode(9877873) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9878513.tgfil(c,e,tp)
	return c:IsFaceup() and c:IsCode(9877918)
end
function c9878513.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9878513.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c9878513.tgfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c9878513.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9878513.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c9878513.tgfil,tp,LOCATION_MZONE,0,1,nil) then 
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c9878513.tgfil,tp,LOCATION_MZONE,0,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT) 
	end
end




