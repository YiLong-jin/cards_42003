--安可人偶
local m=65846697
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,65846687,65846698)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e0:SetCondition(cm.subcon)
	e0:SetValue(cm.subval)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.setcost)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)	
end
function cm.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
function cm.subval(e,c)
	return c:IsRace(RACE_PSYCHO) --c:IsSetCard(0x3ea)
end

function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.setfilter(c)
	return c:IsCode(65846698,65846687) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.fselect(g,a)
	return g:FilterCount(Card.IsCode,nil,65846687)<=1 and (a<=1 and g:FilterCount(Card.IsCode,nil,65846698)<=1 or a>1 and g:FilterCount(Card.IsCode,nil,65846698)<=2)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,2,a)
	if sg and #sg>0 then
		Duel.SSet(tp,sg)
	end
end