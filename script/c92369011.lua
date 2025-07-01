--ディメンション・アトラクター
function c92369011.initial_effect(c)
  --redirect
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(92369011,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_CHAINING)
  e1:SetRange(LOCATION_HAND)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCountLimit(1,92369011)
  e1:SetCost(c92369011.redcost)
  e1:SetOperation(c92369011.redop)
  c:RegisterEffect(e1)
end
function c92369011.redcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c92369011.redop(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():RegisterFlagEffect(RESET_EVENT+RESET_CHAIN,0,1)
end