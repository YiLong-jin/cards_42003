--净源技艺 秘源净化
function c71100332.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100332,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100332)
	e1:SetTarget(c71100332.target)
	e1:SetOperation(c71100332.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100332,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,71100332)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71100332.rmtg)
	e2:SetOperation(c71100332.rmop)
	c:RegisterEffect(e2) 
end
function c71100332.filter(c)
	local atk=c:GetAttack()
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsSetCard(0x47df) and atk>=0 and Duel.IsExistingMatchingCard(c71100332.thfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,atk)
end
function c71100332.thfilter(c,atk)
	return c:IsAbleToHand() and c:IsAttackBelow(atk)
end
function c71100332.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71100332.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71100332.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c71100332.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c71100332.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c71100332.thfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,tc:GetAttack())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c71100332.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,nil,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71100332.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then 
		local rg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_GRAVE,nil,tg:GetFirst():GetCode())
		if #rg>0 then Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) end 
	end
end