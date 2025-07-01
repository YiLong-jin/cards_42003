--绝刀 村正
function c9877741.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9877741+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9877741.target)
	e1:SetOperation(c9877741.activate)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877741,0))
	e11:SetCategory(CATEGORY_EQUIP)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCost(aux.bfgcost)
	e11:SetTarget(c9877741.eqtg)
	e11:SetOperation(c9877741.eqop)
	c:RegisterEffect(e11)
end
function c9877741.filter(c)
	return((c:IsLevel(2) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE))  or c:IsSetCard(0x27eb) ) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9877741.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877741.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877741.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877741.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



function c9877741.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9877741.eqfilter(c,tp)
	return c:IsLevel(2) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsForbidden()
end
function c9877741.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9877741.filter1(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9877741.filter1,tp,LOCATION_MZONE,0,1,c)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9877741.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9877741.filter1,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c9877741.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c9877741.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if ec then
		Duel.Equip(tp,ec,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9877741.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
	end
end
function c9877741.eqlimit(e,c)
	return c==e:GetLabelObject()
end