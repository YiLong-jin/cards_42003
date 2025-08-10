--黑骑士小队-菲特
function c9877616.initial_effect(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,9877616)
	e1:SetTarget(c9877616.thstg) 
	e1:SetOperation(c9877616.thsop) 
	c:RegisterEffect(e1) 

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1877616)
	e3:SetCost(c9877616.cost1)
	e3:SetCondition(c9877616.spcon1)
	e3:SetTarget(c9877616.destg)
	e3:SetOperation(c9877616.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877616.spcon2)
	c:RegisterEffect(e4)
	
end
function c9877616.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877616.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end


function c9877616.thstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c9877616.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  



function c9877616.spfil(c,e,tp) 
	return c:IsAbleToDeck() and c:IsSetCard(0x17ec)
end 
function c9877616.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec) and c:IsType(TYPE_SPELL)
end 
function c9877616.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9877616.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chk==0 then return Duel.IsExistingMatchingCard(c9877616.spfil,tp,LOCATION_GRAVE,0,3,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877616.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c9877616.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(c9877616.tgfil1,tp,LOCATION_DECK,0,nil) 
	if g1:GetCount()>0 then 
	local sg=g1:Select(tp,3,3,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877616,0)) and Duel.CheckLPCost(tp,1500)  then 
			Duel.PayLPCost(tp,1500)
			local xg=g:Select(tp,1,1,nil) 
			Duel.SendtoHand(xg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,xg)
		end
	end
end