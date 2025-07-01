--秘源圣女 阿妮亚
function c71100304.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--remove and to hand  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100304,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,71100304)
	e1:SetTarget(c71100304.rmhtg)
	e1:SetOperation(c71100304.rmhop)
	c:RegisterEffect(e1)
end 
function c71100304.rmfil(c) 
	return c:IsSetCard(0x7de) and c:IsAbleToRemove()
end 
function c71100304.thfil(c) 
	return c:IsSetCard(0x7de) and c:IsAbleToHand()
end 
function c71100304.rmhtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c71100304.rmfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c71100304.thfil,tp,LOCATION_DECK,0,1,nil) end  
	local g=Duel.SelectTarget(tp,c71100304.rmfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c71100304.rmhop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c71100304.thfil,tp,LOCATION_DECK,0,nil)
	if tc:IsRelateToEffect(e) then 
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil)  
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end 
end 











