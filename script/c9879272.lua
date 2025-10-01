--鲑鱼子四宵
function c9879272.initial_effect(c)
	aux.AddCodeList(c,9879202)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879272,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,9879272)  
	e1:SetCost(c9879272.thcost)
	e1:SetTarget(c9879272.thtg)
	e1:SetOperation(c9879272.thop)
	c:RegisterEffect(e1)  
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879272,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1879272)
	e2:SetTarget(c9879272.lvtg)
	e2:SetOperation(c9879272.lvop)
	c:RegisterEffect(e2)
	
end 
function c9879272.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9879272.thfilter(c)
	return aux.IsCodeListed(c,9879202) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9879272.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879272.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879272.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879272.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g) 
	end 
	 local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879272.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end



function c9879272.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(1)
end
function c9879272.lvfilter1(c,tp)
	return c9879272.lvfilter(c) and Duel.IsExistingMatchingCard(c9879272.lvfilter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function c9879272.lvfilter2(c,lv)
	return c9879272.lvfilter(c) and not c:IsLevel(lv)
end
function c9879272.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9879272.lvfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9879272.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9879272.lvfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c9879272.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	local g=Duel.GetMatchingGroup(c9879272.lvfilter,tp,LOCATION_MZONE,0,nil)
	local lc=g:GetFirst()
	while lc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv+2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
	 local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879272.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c9879272.splimit(e,c)
	return not ((c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT))and c:GetAttack()==c:GetDefense())
end