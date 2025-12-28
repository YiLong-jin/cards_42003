--好对手集结
function c9877948.initial_effect(c)
	aux.AddCodeList(c,9877934,9877873)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,9877948+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9877948.thstg) 
	e1:SetOperation(c9877948.thsop) 
	c:RegisterEffect(e1) 
end
function c9877948.thfil(c,tp) 
	return c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c)>0 and c:IsDisabled()
end 
function c9877948.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (aux.IsCodeListed(c,9877934) or aux.IsCodeListed(c,9877873))
end
function c9877948.thstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return c9877948.thfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end 
	if chk==0 then return Duel.IsExistingTarget(c9877948.thfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c9877948.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c9877948.thfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c9877948.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9877948.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
		local sg=Duel.SelectMatchingCard(tp,c9877948.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  









