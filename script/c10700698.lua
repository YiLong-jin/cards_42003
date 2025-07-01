--孽驱的胎动-「666」
function c10700698.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700698,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,10700698)
	e1:SetCondition(c10700698.thcon)
	e1:SetTarget(c10700698.thtg)
	e1:SetOperation(c10700698.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700698,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10700699)
	e2:SetCondition(c10700698.thcon2)
	e2:SetTarget(c10700698.thtg2)
	e2:SetOperation(c10700698.thop2)
	c:RegisterEffect(e2)	
end
function c10700698.thcon(e)
	local tp=e:GetHandler():GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	return tc1:GetOriginalLeftScale()==tc2:GetOriginalRightScale()
end
function c10700698.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c10700698.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700698.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700698.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)  and c:IsAbleToExtra()
end
function c10700698.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700698.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 
		   and Duel.IsExistingMatchingCard(c10700698.tefilter,tp,LOCATION_DECK,0,1,nil)
		   and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 
		   and Duel.SelectYesNo(tp,aux.Stringid(10700698,2)) then
			 Duel.ConfirmCards(1-tp,g)
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=Duel.SelectMatchingCard(tp,c10700698.tefilter,tp,LOCATION_DECK,0,1,1,nil)
			 if #sg>0 then
				   Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
			 end
		end
	end
end
function c10700698.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and rp==tp
end
function c10700698.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10700698.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700698.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10700698.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10700698.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end