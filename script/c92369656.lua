function c92369656.initial_effect(c)
  aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8d),aux.NonTuner(Card.IsSetCard,0x8d),1)
  c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(92369656,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetTarget(c92369656.target)
  e1:SetOperation(c92369656.operation)
  c:RegisterEffect(e1)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(92369656,0))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetTarget(c92369656.target)
  e3:SetOperation(c92369656.operation)
  c:RegisterEffect(e3)
  --turn set
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(92369656,1))
  e2:SetCategory(CATEGORY_POSITION)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(c92369656.postg)
  e2:SetOperation(c92369656.posop)
  c:RegisterEffect(e2)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(92369656,2))
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e4:SetCountLimit(1,92369656)
  e4:SetTarget(c92369656.tftg)
  e4:SetOperation(c92369656.tfop)
  c:RegisterEffect(e4)
end
function c92369656.postg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(92369656)==0 end
  c:RegisterFlagEffect(92369656,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c92369656.posop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
  end
end
function c92369656.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c92369656.tdfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c92369656.operation(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(1,0)
  e1:SetValue(function(e,re,tp) return not re:GetHandler():IsSetCard(0x8d) end)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c92369656.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
function c92369656.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and c92369656.tffilter(chkc) end
  if chk==0 then
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<-1 then return false end
    local loc=LOCATION_ONFIELD
    if ft==0 then loc=LOCATION_MZONE end
    e:SetLabel(loc)
    return Duel.IsExistingTarget(c92369656.tffilter,tp,loc,0,1,nil)
    and Duel.IsExistingMatchingCard(c92369656.tdfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c92369656.tffilter,tp,e:GetLabel(),0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92369656.tfop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local tc=Duel.GetFirstTarget()
  g=Duel.SelectMatchingCard(tp,c92369656.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
  if tc:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) then
    Duel.BreakEffect()
    Duel.Overlay(tc,e:GetHandler())
  end
end
function c92369656.thfilter(c)
  return c:IsSetCard(0x8d) and c:IsAbleToGrave()
end
function c92369656.tdfilter(c)
  return c:IsSetCard(0x8d) and c:IsAbleToDeck()
end
function c92369656.tffilter(c)
  return c:IsCode(92369656,53334641) and c:IsAbleToGrave()
end