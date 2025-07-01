--ゴーストリック・ランタン
function c92369679.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c92369679.sumcon)
	c:RegisterEffect(e1)
	--turn set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92369679,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c92369679.postg)
	e2:SetOperation(c92369679.posop)
	c:RegisterEffect(e2)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_HAND)
	e7:SetCondition(c92369679.condition)
	e7:SetOperation(c92369679.aaa)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(92369679,0))
	e8:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCountLimit(1,92369679)
	e8:SetTarget(c92369679.thtg)
	e8:SetOperation(c92369679.thop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
--  local e3=Effect.CreateEffect(c)
--  e3:SetDescription(aux.Stringid(92369679,1))
--  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
--  e3:SetType(EFFECT_TYPE_QUICK_O)
--  e3:SetCode(EVENT_CHAINING)
--  e3:SetRange(LOCATION_HAND)
--  e3:SetCondition(c92369679.spcon1)
--  e3:SetTarget(c92369679.sptg)
--  e3:SetOperation(c92369679.spop)
--  c:RegisterEffect(e3)
end
function c92369679.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92369679.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c92369679.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c92369679.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c92369679.thfilter(c)
	return c:IsSetCard(0x8d) and c:IsAbleToHand()
end
function c92369679.condition(e,tp,eg,ep,ev,re,r,rp)
  local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
 end
function c92369679.aaa(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c) return not c:IsSetCard(0x8d) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c92369679.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8d)
end
function c92369679.sumcon(e)
	return not Duel.IsExistingMatchingCard(c92369679.sfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c92369679.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(92369679)==0 end
	c:RegisterFlagEffect(92369679,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c92369679.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
--function c92369679.spcon1(e,tp,eg,ep,ev,re,r,rp)
--  if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
--  if re:IsHasCategory(CATEGORY_NEGATE)
--	  and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
--  local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
--  return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
--end
--function c92369679.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return true end
--  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
--  if re:GetHandler():IsRelateToEffect(re) then
--	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
--  end
--  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_HAND)>0
--	  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
--end
--function c92369679.spop(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
--	  Duel.Destroy(eg,REASON_EFFECT)
--  end
--	  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
--		  Duel.ConfirmCards(1-tp,c)
--	  end
--end
