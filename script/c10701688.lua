--阴云精－层状云
function c10701688.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,10701688+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c10701688.spcon)
	e0:SetOperation(c10701688.spop)
	c:RegisterEffect(e0)  
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701688,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10701689)
	e1:SetTarget(c10701688.optg)
	e1:SetOperation(c10701688.opop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10701688.con)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701688,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10701690)
	e2:SetTarget(c10701688.thtg)
	e2:SetOperation(c10701688.thop)
	c:RegisterEffect(e2)   
end
function c10701688.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10701673)
end
function c10701688.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST)
end
function c10701688.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST)
end
function c10701688.lvfilter(c,e,tp,lv)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER) and ((((c:IsLevelAbove(1) and e:GetHandler():IsLocation(LOCATION_MZONE) and not c:IsLevel(lv)) or c:IsType(TYPE_XYZ)) and e:GetHandler():IsAttribute(ATTRIBUTE_WATER)) or (Duel.IsExistingMatchingCard(c10701688.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)))
end
function c10701688.setfilter(c)
	return (c:IsCode(90263923) or c:IsSetCard(0x7c1)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10701688.optg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) or (chkc:IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(tp,10701673))) and chkc:IsControler(tp) and c10701688.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c10701688.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701688.lvfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,e:GetHandler():GetLevel())
end
function c10701688.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	 if c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c10701688.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701688.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g==0 then return end
		Duel.SSet(tp,g:GetFirst())
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
function c10701688.thfilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10701688.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701688.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701688.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701688.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end