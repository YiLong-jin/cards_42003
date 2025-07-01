--暗黑界的混沌王
function c90309059.initial_effect(c)
 --fusion material
   c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,90309058,aux.FilterBoolFunction(Card.IsFusionSetCard,0x006),1,1,true,true)  
--Atk up 
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c90309059.con)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
 --To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90309059,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c90309059.thcon)
	e2:SetTarget(c90309059.thtg)
	e2:SetOperation(c90309059.thop)
	c:RegisterEffect(e2)
end
function c90309059.con(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c90309059.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c90309059.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x6) 
end
function c90309059.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90309059.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90309059.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c90309059.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

