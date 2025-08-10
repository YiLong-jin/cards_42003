--黄昏怪盗团-闪光
function c9877489.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877489,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9877489)
	e1:SetCondition(c9877489.xthcon)
	e1:SetTarget(c9877489.xthtg)
	e1:SetOperation(c9877489.xthop)
	c:RegisterEffect(e1)

	 local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877489,2))
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e11:SetCountLimit(1,1877489)
	e11:SetCost(c9877489.descost)
	e11:SetTarget(c9877489.mattg)
	e11:SetOperation(c9877489.matop)
	c:RegisterEffect(e11)

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9877489,3))
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e12:SetCountLimit(1,1877489)
	e12:SetCost(c9877489.spcost)
	e12:SetTarget(c9877489.mattg)
	e12:SetOperation(c9877489.matop)
	c:RegisterEffect(e12)
end
function c9877489.xthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9877489.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877489.xthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9877489.costfilter(c)
	return c:GetControler()~=c:GetOwner() and c:IsDiscardable()
end
function c9877489.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877489.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c9877489.costfilter,1,1,REASON_COST+REASON_DISCARD)
end



function c9877489.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9877489.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9877489.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if c:IsRelateToEffect(e) and g:GetCount()==1 then
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,g)
	end
end