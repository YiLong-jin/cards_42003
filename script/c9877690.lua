--来自“过去”的首领
function c9877690.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9877690)
	e1:SetCondition(c9877690.spcon)
	e1:SetTarget(c9877690.sptg)
	e1:SetOperation(c9877690.spop)
	c:RegisterEffect(e1) 

	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9877690,1))
	e4:SetCategory(CATEGORY_TOHAND) 
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,1877690)
	e4:SetCost(c9877690.negcost)
	e4:SetTarget(c9877690.tgtg1) 
	e4:SetOperation(c9877690.tgop1) 
	c:RegisterEffect(e4) 
	
end
function c9877690.f(c)
	return c:IsFaceup() and  c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end
function c9877690.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9877690.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9877690.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877690.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c9877690.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9877690.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec)
end 
function c9877690.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877690.tgfil1,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end 
function c9877690.tgop1(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877690.tgfil1,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,sg)~=0 and Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(9877690,0))  then 
				Duel.PayLPCost(tp,500)
				local e11=Effect.CreateEffect(e:GetHandler())
				e11:SetDescription(aux.Stringid(9877690,2))
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_ADD_CODE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e11:SetValue(9873056)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e11)
				local e15=Effect.CreateEffect(c)
				e15:SetType(EFFECT_TYPE_FIELD)
				e15:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e15:SetRange(LOCATION_MZONE)
				e15:SetTargetRange(LOCATION_MZONE,0)
				e15:SetTarget(c9877690.indtg)
				e15:SetValue(1)
				e15:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e15)
		end
	end 
end
function c9877690.indtg(e,c)
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_LINK)
end