--亘古不变的奸奇万变传说
function c21400065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,21400065)
	e1:SetTarget(c21400065.target)
	e1:SetOperation(c21400065.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400065)
	e2:SetCondition(c21400065.setcon)  
	e2:SetTarget(c21400065.settg)
	e2:SetOperation(c21400065.setop)
	c:RegisterEffect(e2)
end
c21400065.toss_coin=true 
function c21400065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerAffectedByEffect(EFFECT_CANNOT_TO_HAND) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c21400065.thfil1(c)
	return c:IsSetCard(0x3210) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21400065.thfil2(c)
	return c:IsSetCard(0x3210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c21400065.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local res=2 
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) then 
		res=Duel.SelectOption(tp,aux.Stringid(21400065,1),aux.Stringid(21400065,2))
	else 
		res=1-Duel.TossCoin(tp,1) 
	end 
	if res==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c21400065.thfil1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c21400065.thfil2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c21400065.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c21400065.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c21400065.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c) 
	end
end 



