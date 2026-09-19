--黎明圣地·魔蛋堆
function c9879437.initial_effect(c)
	c:SetUniqueOnField(1,0,9879437)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,9879437+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)	 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1879437)
	e2:SetCondition(c9879437.spcon1)
	e2:SetTarget(c9879437.thtg) 
	e2:SetOperation(c9879437.thop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--to deck 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED) 
	e4:SetCountLimit(1,1879437)  
	e4:SetTarget(c9879437.tdstg) 
	e4:SetOperation(c9879437.tdsop) 
	c:RegisterEffect(e4) 
end
function c9879437.cfilter1(c)
	return c:IsFaceup() and c:IsDefense(400) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c9879437.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879437.cfilter1,1,nil)
end
function c9879437.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x1eac) and c:IsType(TYPE_MONSTER) 
end 
function c9879437.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879437.thfil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c9879437.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879437.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)  
	end 
end  

function c9879437.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsDefense(400) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(4)   
end 
function c9879437.tdstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c9879437.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
end 
function c9879437.tdsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879437.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 