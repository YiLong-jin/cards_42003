--无论如何谨贺新年
function c9879353.initial_effect(c)
	aux.AddCodeList(c,9877934,9877873)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c9879353.thstg) 
	e1:SetOperation(c9879353.thsop) 
	c:RegisterEffect(e1) 
end
function c9879353.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (aux.IsCodeListed(c,9877934) or aux.IsCodeListed(c,9877873))
end
function c9879353.cfilter(c)
	return  c:GetControler()~=c:GetOwner()
end
function c9879353.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879353.cfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil)
end
function c9879353.thstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return c9879353.thfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end 
	if chk==0 then return Duel.IsExistingMatchingCard(c9879353.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c9879353.thsop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.IsExistingMatchingCard(c9879353.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
		local sg=Duel.SelectMatchingCard(tp,c9879353.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  