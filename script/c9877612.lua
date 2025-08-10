--黑骑士小队跃进
function c9877612.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(9877612)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9877612,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9877612)
	e4:SetCost(c9877612.negcost)
	e4:SetTarget(c9877612.tgtg1) 
	e4:SetOperation(c9877612.tgop1) 
	c:RegisterEffect(e4) 


end
function c9877612.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9877612.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec)
end 
function c9877612.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877612.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877612.tgfil1,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9877612.tgop1(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877612.tgfil1,tp,LOCATION_DECK,0,nil) 
	local g1=Duel.GetMatchingGroup(c9877612.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,sg)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,1000) and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877612,0))  then 
		Duel.PayLPCost(tp,1000)
		local xg=g1:Select(tp,1,1,nil) 
		Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9877612.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9877612.splimit(e,c)
	return not c:IsSetCard(0x17ec) 
end