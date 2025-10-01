--鲑鱼子七宵
function c9879274.initial_effect(c)
	 aux.AddCodeList(c,9879202)
	aux.AddXyzProcedure(c,c9879274.mfilter,4,2)
	c:EnableReviveLimit() 

	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c9879274.atkfilter)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c) 
	e11:SetDescription(aux.Stringid(9879274,0))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e11:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e11:SetProperty(EFFECT_FLAG_DELAY) 
	e11:SetCountLimit(1,9879274) 
	e11:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end) 
	e11:SetTarget(c9879274.thtg) 
	e11:SetOperation(c9879274.thop)  
	c:RegisterEffect(e11) 
	--ov 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(9879274,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1879274) 
	e2:SetCost(c9879274.ovcost)
	e2:SetTarget(c9879274.ovtg) 
	e2:SetOperation(c9879274.ovop) 
	c:RegisterEffect(e2) 
	
end
function c9879274.atkfilter(e,c)
	return c:IsAttackPos()
end
function c9879274.mfilter(c)
	return aux.IsCodeListed(c,9879202)
end


function c9879274.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c9879274.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end   
end 
function c9879274.ovcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end 
function c9879274.ovfil(c) 
	return c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end 
function c9879274.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879274.ovfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end  
end 
function c9879274.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879274.ovfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
		local og=g:Select(tp,1,1,nil) 
		Duel.Overlay(c,og) 
	end 
end 