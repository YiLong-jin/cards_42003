--爱意的约会·芙蕾德莉卡
function c9879057.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,9879057)
	e1:SetTarget(c9879057.target)
	e1:SetOperation(c9879057.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9879057.drcon)
	e2:SetOperation(c9879057.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c9879057.atkval)
	c:RegisterEffect(e3)
end
function c9879057.filter(c)
	return c:IsCode(9879053)  and c:IsAbleToHand()
end

function c9879057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879057.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c9879057.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879057.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>=0 then 
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9879057.cfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsCanHaveCounter(0x7e2)
end
function c9879057.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879057.cfilter1,1,nil,tp)
end
function c9879057.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,100,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0x7e2,1)
	end
end


function c9879057.atkval(e,c)
	return e:GetHandler():GetCounter(0x7e2)*(-100)
end