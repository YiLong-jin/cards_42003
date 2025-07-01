--村正武士-鬼神野首里
function c9877745.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877745,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,9877745)
	e2:SetTarget(c9877745.thtg)
	e2:SetOperation(c9877745.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)

	 local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(9877745,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_IGNITION) 
	e14:SetRange(LOCATION_MZONE) 
	e14:SetCountLimit(1,1877745)
	e14:SetCondition(c9877745.eqcon)
	e14:SetTarget(c9877745.tgtg) 
	e14:SetOperation(c9877745.tgop) 
	c:RegisterEffect(e14) 
	
end
function c9877745.spfilter(c,e,tp)
	return c:IsSetCard(0x27eb) and c:IsAbleToHand()
end
function c9877745.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877745.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877745.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877745.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



function c9877745.eqcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()>0
end
function c9877745.tgfil(c) 
	return c:IsAbleToHand() and ((c:IsLevel(2) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE))  or c:IsSetCard(0x27eb) ) and c:IsFaceup()
end 
function c9877745.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877745.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c9877745.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877745.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end 
end 