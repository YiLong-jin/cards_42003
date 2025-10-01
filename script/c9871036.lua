--薇特莉斯甜点工坊-果果蛋糕酱
function c9871036.initial_effect(c)
	c:SetUniqueOnField(1,0,9871036)
	
	  local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,9871036)  
	e1:SetTarget(c9871036.thtg) 
	e1:SetOperation(c9871036.thop)  
	c:RegisterEffect(e1) 
end
function c9871036.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_MZONE) 
end 
function c9871036.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end   
end 