--幽居于刹那芳华
function c10700835.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c10700835.acop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	e3:SetOperation(c10700835.acop2)
	c:RegisterEffect(e3)
	--def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c10700835.atktg)
	e4:SetValue(c10700835.atkval)
	c:RegisterEffect(e4)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700835,2))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c10700835.thcost)
	e5:SetTarget(c10700835.thtg)
	e5:SetOperation(c10700835.thop)
	c:RegisterEffect(e5)
	--tograve
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10700835,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(c10700835.tgcost)
	e6:SetTarget(c10700835.tgtg)
	e6:SetOperation(c10700835.tgop)
	c:RegisterEffect(e6)
	--handes
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10700835,0))
	e7:SetCategory(CATEGORY_HANDES)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCost(c10700835.cost)
	e7:SetTarget(c10700835.tg)
	e7:SetOperation(c10700835.op)
	c:RegisterEffect(e7)
end
function c10700835.cfilter1(c)
	return c:IsAbleToHand()
end
function c10700835.acop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c10700835.cfilter1,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x107c,ct,true)
	end
end
function c10700835.cfilter2(c)
	return c:IsAbleToDeck() or c:IsAbleToExtra()
end
function c10700835.acop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c10700835.cfilter2,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x107c,ct,true)
	end
end
function c10700835.atktg(e,c)
	return c:IsFaceup() and c:IsStatus(STATUS_SPSUMMON_TURN)
		and c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and c:IsSummonLocation(LOCATION_EXTRA)
end
function c10700835.atkval(e,c)
	return -c:GetBaseAttack()
end
function c10700835.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x107c,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x107c,6,REASON_COST)
end
function c10700835.thfilter(c)
	return ((c:IsSetCard(0x7cc) and c:IsType(TYPE_MONSTER)) or c:IsCode(10700779)) and c:IsAbleToHand()
end
function c10700835.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700835.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c10700835.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700835.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10700835.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x107c,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x107c,4,REASON_COST)
end
function c10700835.tgfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsSetCard(0x7cc) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
end
function c10700835.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c10700835.filter2,tp,LOCATION_ONFIELD+LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c10700835.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10700835.tgfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function c10700835.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x107c,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x107c,2,REASON_COST)
end
function c10700835.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c10700835.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end