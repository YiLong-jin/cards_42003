--薇特莉斯甜点工坊-叶叶
function c9877344.initial_effect(c)
	 aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x17e4),4,2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877344,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9877344)
	e1:SetCondition(c9877344.xthcon)
	e1:SetTarget(c9877344.xthtg)
	e1:SetOperation(c9877344.xthop)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c) 
	e11:SetDescription(aux.Stringid(9877344,0)) 
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)   
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE) 
	e11:SetCountLimit(1,1877344)  
	e11:SetCost(c9877344.spcost)
	e11:SetTarget(c9877344.sptg) 
	e11:SetOperation(c9877344.spop) 
	c:RegisterEffect(e11) 
	
end
function c9877344.xthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9877344.xthfilter(c)
	return c:IsSetCard(0x17e4) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9877344.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877344.xthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9877344.xthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877344.xthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9877344.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c9877344.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17e4) and c:IsFaceup()
end 
function c9877344.sptg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingMatchingCard(c9877344.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c9877344.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877344.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end