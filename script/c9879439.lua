--黎明圣地·探索者人偶
function c9879439.initial_effect(c)
	aux.AddCodeList(c,9879431)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879434,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9879439)
	e1:SetCondition(c9879439.spcon)
	e1:SetTarget(c9879439.sptg)
	e1:SetOperation(c9879439.spop)
	c:RegisterEffect(e1)  
	
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9879439+9879439)
	e2:SetCondition(c9879439.thcon)
	e2:SetTarget(c9879439.thtg) 
	e2:SetOperation(c9879439.thop) 
	c:RegisterEffect(e2) 
end
function c9879439.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1eac) or c:IsCode(9879431))   
end
function c9879439.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879439.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9879439.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879439.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c9879439.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end 
function c9879439.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x1eac)  
end 
function c9879439.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879439.thfil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c9879439.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879439.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)  
	end 
end  