--巨石遗物的仪式者 竺孑
local m=65846751
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=aux.AddRitualProcGreater2(c,cm.aa,nil,nil,cm.ab,true)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.ac)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.ba)
	e2:SetTarget(cm.bb)
	e2:SetOperation(cm.bc)
	c:RegisterEffect(e2)
end
function cm.aa(c,e,tp,chk)
	return c:IsSetCard(0x138) and (not chk or c~=e:GetHandler())
end
function cm.ab(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function cm.ac(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.ba(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_RITUAL and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_RELEASE)
end
function cm.aaa(c)
	return  c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tdfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x138) and c:IsAbleToHand() and Duel.IsExistingTarget(cm.aaa,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,nil)
end
function cm.fselect(g)
	return g:FilterCount(function(c) return c:IsSetCard(0x138) end,nil)>0 and g:FilterCount(function(c) return bit.band(c:GetType(),0x81)==0x81 end,nil)>0
end
function cm.bb(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(function(c,e) return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsAbleToHand() and (bit.band(c:GetType(),0x81)==0x81 or c:IsSetCard(0x138)) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function cm.bc(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
