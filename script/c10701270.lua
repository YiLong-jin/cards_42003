--变形斗士·磁场
function c10701270.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10701270.activate)
	c:RegisterEffect(e1)	
	--position 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2645637,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10701270.poscon)
	e2:SetTarget(c10701270.postg)
	e2:SetOperation(c10701270.posop)
	c:RegisterEffect(e2)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,10701270)
	e3:SetCondition(c10701270.thcon)
	e3:SetTarget(c10701270.thtg)
	e3:SetOperation(c10701270.thop)
	c:RegisterEffect(e3)
end
function c10701270.thfilter(c)
	return c:IsSetCard(0x26) and c:IsAbleToHand() 
end
function c10701270.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10701270.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,10701270)==0 and Duel.SelectYesNo(tp,aux.Stringid(10701270,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.RegisterFlagEffect(tp,10701270,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end 
end
function c10701270.poscon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and (re:GetHandler():IsSetCard(0x26) or re:GetHandler():IsSetCard(0xc2)) and rp==tp 
end
function c10701270.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10701270.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsPosition(POS_FACEUP_ATTACK) then
		  local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE+POS_FACEDOWN_DEFENSE)
		  Duel.ChangePosition(tc,pos)
		elseif tc:IsPosition(POS_FACEUP_DEFENSE) then
		  local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		  Duel.ChangePosition(tc,pos)
		else
		  local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
		  Duel.ChangePosition(tc,pos)
		end
	end
end
function c10701270.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc2) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c10701270.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701270.cfilter,1,nil)
end
function c10701270.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c10701270.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701270.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701270.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701270.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end