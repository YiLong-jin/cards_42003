--阴云精－波状云
function c10701681.initial_effect(c)
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701681,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10701681)
	e1:SetTarget(c10701681.optg)
	e1:SetOperation(c10701681.opop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10701681.con)
	c:RegisterEffect(e3)
	--postion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701681,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10701682)
	e2:SetTarget(c10701681.postg)
	e2:SetOperation(c10701681.posop)
	c:RegisterEffect(e2)	 
end
function c10701681.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10701673)
end
function c10701681.lvfilter(c,e,tp,lv)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER) and ((((c:IsLevelAbove(1) and e:GetHandler():IsLocation(LOCATION_MZONE) and not c:IsLevel(lv)) or c:IsType(TYPE_XYZ)) and e:GetHandler():IsAttribute(ATTRIBUTE_WATER)) or (Duel.IsExistingMatchingCard(c10701681.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)))
end
function c10701681.tgfilter(c)
	return (c:IsSetCard(0x7c1) or c:IsRace(RACE_THUNDER)) and c:IsAbleToGrave()
end
function c10701681.optg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) or (chkc:IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(tp,10701673))) and chkc:IsControler(tp) and c10701681.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c10701681.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701681.lvfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,e:GetHandler():GetLevel())
end
function c10701681.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	 if c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c10701681.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c10701681.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		 Duel.SendtoGrave(g,REASON_EFFECT)
		end
	 end
	 if c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and tc:IsFaceup() and c:GetLevel()~=tc:GetLevel() and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	 end
	 if c:IsAttribute(ATTRIBUTE_WATER) and tc:IsType(TYPE_XYZ) then
		Duel.Overlay(tc,Group.FromCards(c))
	 end
end 
function c10701681.filter(c)
	return c:IsCanChangePosition()
end
function c10701681.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701681.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701681.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c10701681.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10701681.posop(e,tp,eg,ep,ev,re,r,rp)
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
	if tc:IsPosition(POS_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(10701681,2)) then
	   Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	   e1:SetValue(ATTRIBUTE_LIGHT)
	   tc:RegisterEffect(e1)
	end
end