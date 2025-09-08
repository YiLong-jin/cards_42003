--水银秘主-爱莎
function c9877505.initial_effect(c)
	aux.AddCodeList(c,9877505)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,9877505)
	e1:SetCondition(c9877505.spcon)
	c:RegisterEffect(e1) 
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877505,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1877505)
	e2:SetTarget(c9877505.target)
	e2:SetOperation(c9877505.operation)
	c:RegisterEffect(e2)
	
	local e12=Effect.CreateEffect(c) 
	e12:SetDescription(aux.Stringid(9877505,2))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e12:SetType(EFFECT_TYPE_IGNITION) 
	e12:SetRange(LOCATION_MZONE) 
	e12:SetCountLimit(1,1877505) 
	e12:SetCost(c9877505.thcost) 
	e12:SetTarget(c9877505.thtg) 
	e12:SetOperation(c9877505.thop)  
	c:RegisterEffect(e12)

	
end
function c9877505.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c9877505.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c9877505.cfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end


function c9877505.spfil(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877505.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9877505.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9877505.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9877505.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c9877505.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL)
end 
function c9877505.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877505.ctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c9877505.ctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end  
function c9877505.thfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,9877505)
end 
function c9877505.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877505.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c9877505.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9877505.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)  
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end 
end 