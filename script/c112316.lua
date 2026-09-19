--
function c112316.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)	 
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCountLimit(1,012316)
	e1:SetOperation(c112316.activate)   
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112316,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,112316)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c112316.cost)
	e2:SetTarget(c112316.target)
	e:SetOperation(c112316.operation)
	c:RegisterEffect(e2)
end
function c112316.thfilter(c)	
	return c:IsType(TYPE_MONSTER) and （c:IsSetCard(0x0ca8) or c:IsSetCard(0x0ca7)） and c:IsAbleToHand() 
end 
function c112316.activate(e,tp,eg,ep,ev,re,r,rp)	
	if not e:GetHandler():IsRelateToEffect(e) then return end   
	local g=Duel.GetMatchingGroup(c112316.thfilter,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(112316,0)) then	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)		
	local sg=g:Select(tp,1,1,nil)	   
	Duel.SendtoHand(sg,nil,REASON_EFFECT)	   
	Duel.ConfirmCards(1-tp,sg)  
end 
end
function c112316.cost(e,tp,eg,ep,ev,re,r,rp)	
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end 
function c112316.filter(c,e,sp)	 
	return (c:IsSetCard(0x0ca8) or c:IsSetCard(0x0ca7)) and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and c:IsLevelBelow(6)
end 
function c112316.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c112316.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end 
function c112316.operation(e,tp,eg,ep,ev,re,r,rp)   
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local g=Duel.SelectMatchingCard(tp,c112316.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
	if g:GetCount()>0 then	  
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
	 local e1=Effect.CreateEffect(e:GetHandler()) 
	 e1:SetType(EFFECT_TYPE_FIELD)   
	 e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	 e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)	
	 e1:SetReset(RESET_PHASE+PHASE_END) 
	 e1:SetTargetRange(1,0)  
	 e1:SetTarget(c112316.splimit)   
	 Duel.RegisterEffect(e1,tp) 
	end 
end 
function c112316.splimit(e,c,sump,sumtype,sumpos,targetp,se) 
	return not c:IsSetCard(0x0ca8) and not c:IsSetCard(0x0ca7) and c:IsLocation(LOCATION_EXTRA) 
end