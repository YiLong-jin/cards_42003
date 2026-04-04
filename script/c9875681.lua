--协证曲的相遇
function c9875681.initial_effect(c)
	aux.AddCodeList(c,9875667)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9875681,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9875681) 
	e1:SetTarget(c9875681.actg1) 
	e1:SetOperation(c9875681.acop1)  
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(9875681,2))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES) 
	e2:SetType(EFFECT_TYPE_ACTIVATE) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetCountLimit(1,1875681) 
	e2:SetTarget(c9875681.actg2) 
	e2:SetOperation(c9875681.acop2)  
	c:RegisterEffect(e2)
end 
function c9875681.tgfil1(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()  
end 
function c9875681.actg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875681.tgfil1,tp,LOCATION_SZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9875681.tgfil1,tp,LOCATION_SZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c9875681.aspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsCode(9875680) 
end 
function c9875681.acop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsSetCard(0x2ea7) and Duel.IsExistingMatchingCard(c9875681.aspfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9875681,3)) then 
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c9875681.aspfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c9875681.tgfil2(c) 
	return c:IsType(TYPE_MONSTER)and c:IsSetCard(0x2ea7) and c:IsAbleToGrave()  
end 
function c9875681.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(9875680) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c9875681.tgfil2,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
end  
function c9875681.plfil(c) 
	return c:IsCode(9875667) and not c:IsForbidden()	
end 
function c9875681.acop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9875681.tgfil2,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsCode(9875674) and Duel.IsExistingMatchingCard(c9875681.plfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9875681,4)) then 
			local tc=Duel.SelectMatchingCard(tp,c9875681.plfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()  
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
		end   
	end  
end 







