--冥符「红色的冥界」
function c8777631.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)


	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1ea1))
	e2:SetValue(c8777631.efilter)
	c:RegisterEffect(e2)


	 local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(8777631,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1,8777631) 
	e3:SetCost(c8777631.spcost)
	e3:SetTarget(c8777631.sptg) 
	e3:SetOperation(c8777631.spop) 
	c:RegisterEffect(e3) 

	local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(8777631,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_IGNITION) 
	e14:SetRange(LOCATION_SZONE) 
	e14:SetCountLimit(1,8777631)
	e14:SetTarget(c8777631.tgtg) 
	e14:SetOperation(c8777631.tgop) 
	c:RegisterEffect(e14) 

	
end
function c8777631.efilter(e,re)
   return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end


function c8777631.tgfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x1ea1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end 
function c8777631.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777631.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c8777631.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c8777631.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end 
end 



function c8777631.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,500) end  
	Duel.PayLPCost(tp,500) 
end 
function c8777631.spfil(c,e,tp) 
	return c:IsSetCard(0x1ea1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and c:IsFaceup()
end 
function c8777631.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c8777631.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)   
end 
function c8777631.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c8777631.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 