--气符「地龙天龙脚」
function c8777640.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,8777640)   
	e1:SetCondition(c8777640.condition)
	e1:SetTarget(c8777640.target)
	e1:SetOperation(c8777640.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8777640,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,8777640)
	e2:SetCost(c8777640.thcost1)
	e2:SetTarget(c8777640.thtg1)
	e2:SetOperation(c8777640.thop1)
	c:RegisterEffect(e2)
end
function c8777640.f(c)
	return c:IsFaceup() and c:IsSetCard(0x1ea3)
end
function c8777640.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c8777640.f,tp,LOCATION_MZONE,0,nil)
	return eg:GetFirst():IsControler(1-tp) and #g>0 
end
function c8777640.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_DEFENSE) end
end
function c8777640.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	local g2=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local ga=g1:GetMinGroup(Card.GetAttack)
	local gd=g2:GetMaxGroup(Card.GetDefense)
	if ga:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(8777640,0))
		ga=ga:Select(tp,1,1,nil)
	end
	if gd:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(8777640,1))
		gd=gd:Select(tp,1,1,nil)
	end
	Duel.NegateAttack()
	local a=ga:GetFirst()
	local d=gd:GetFirst()
	if a:IsAttackable() and not a:IsImmuneToEffect(e) and not d:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,d)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end

function c8777640.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c8777640.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c8777640.thop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end