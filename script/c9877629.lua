--黑骑士小队-天穹
function c9877629.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877629,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877629)
	e1:SetCondition(c9877629.spcon)
	e1:SetTarget(c9877629.sptg)
	e1:SetOperation(c9877629.spop)
	c:RegisterEffect(e1)

	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9877629,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,1877629)
	e4:SetCost(c9877629.negcost)
	e4:SetCondition(c9877629.spcon1)
	e4:SetTarget(c9877629.tgtg1) 
	e4:SetOperation(c9877629.tgop1) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c9877629.spcon2)
	c:RegisterEffect(e5)
	
end
function c9877629.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877629.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end


function c9877629.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9877629.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9877629.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end



function c9877629.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9877629.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec)
end 
function c9877629.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877629.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877629.tgfil1,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c9877629.tgop1(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877629.tgfil1,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,sg)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c9877629.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9877629,0))  then 
		Duel.PayLPCost(tp,1000)
		local xg=Duel.SelectMatchingCard(tp,c9877629.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9877629.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9877629.splimit(e,c)
	return not c:IsSetCard(0x17ec) 
end