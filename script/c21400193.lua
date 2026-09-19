--恐虐荣光挑战者
function c21400193.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400193) 
	e1:SetTarget(c21400193.sptg)
	e1:SetOperation(c21400193.spop)
	c:RegisterEffect(e1)  
	--tdd
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,21400194) 
	e1:SetCondition(function(e) 
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer() end)
	e1:SetTarget(c21400193.tddtg)
	e1:SetOperation(c21400193.tddop)
	c:RegisterEffect(e1)  
end
function c21400193.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400193.sthfil(c) 
	return c:IsSetCard(0x6210) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end 
function c21400193.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsSetCard(0x6210) and Duel.IsExistingMatchingCard(c21400193.sthfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21400193,0)) then 
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c21400193.sthfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end
end
function c21400193.tdfil(c) 
	return c:IsAbleToDeck() and c:IsSetCard(0x6210)   
end 
function c21400193.tdgck(g,e) 
	return g:IsContains(e:GetHandler())  
end
function c21400193.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c21400193.tdfil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c21400193.tdgck,3,3,e) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE) 
end 
function c21400193.tddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21400193.tdfil,tp,LOCATION_GRAVE,0,nil)
	if g:CheckSubGroup(c21400193.tdgck,3,3,e) then 
		local sg=g:SelectSubGroup(tp,c21400193.tdgck,false,3,3,e) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
			Duel.Draw(tp,1,REASON_EFFECT)
		end 
	end 
end 

