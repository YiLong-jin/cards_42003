--毒蝶-暴毒者
function c10701902.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10701902.splimit)
	c:RegisterEffect(e0)   
	--search 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701902,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10701902)
	e1:SetCost(c10701902.thcost)
	e1:SetTarget(c10701902.thtg)
	e1:SetOperation(c10701902.thop)
	c:RegisterEffect(e1)
	--recover 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701902,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10701903)
	e2:SetTarget(c10701902.rectg)
	e2:SetOperation(c10701902.recop)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10701902.damtg)
	e3:SetOperation(c10701902.damop)
	c:RegisterEffect(e3)
end
function c10701902.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(10701900)
end
function c10701902.cfilter(c,tp)
	return c:IsRace(RACE_INSECT) and (c:IsControler(tp) or c:IsFaceup())
end
function c10701902.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c10701902.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c10701902.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c10701902.thfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_MONSTER) and not c:IsCode(10701902)
		and not c:IsSummonableCard() and c:IsAbleToHand()
end
function c10701902.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701902.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701902.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701902.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10701902.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local owner=e:GetHandler():GetOwner() 
	Duel.SetTargetPlayer(owner)
	Duel.SetTargetParam(2700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,owner,2700)
end
function c10701902.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c10701902.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end

function c10701902.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end