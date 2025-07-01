--CAN－Melo：D
local m=65846675
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,65846670)
	c:EnableReviveLimit()
	--aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	aux.AddXyzProcedureLevelFree(c,function(c) return c:IsRace(RACE_PSYCHO) end,cm.xyzcheck,2,2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c65846675.lvtg)
	e0:SetValue(c65846675.lvval)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846678,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cost)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.cvcon)
	e3:SetTarget(cm.cvtg)
	e3:SetOperation(cm.cvop)
	--c:RegisterEffect(e3)
end
function cm.xyzcheck(g)
	return g:IsExists(function(c) return c:IsCode(65846670) end,1,nil)
end
function cm.cvcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c65846675.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.xyzcheck(g)
	return g:IsExists(function(c) return c:IsCode(65846670) end,1,nil) and g:GetClassCount(Card.GetRace)==1 and g:IsExists(function(c) return c:IsRace(RACE_PSYCHO) end,1,nil) and (g:IsExists(function(c) return c:IsLevel(7) end,1,nil) or g:IsExists(function(c) return c:IsCode(65846670) end,2,nil))
end
function c65846675.mtfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c65846675.cvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c65846675.mtfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
end
function c65846675.cvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c65846675.mtfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,e)
	if g:GetCount()>0 then
		local mg=g:GetFirst():GetOverlayGroup()
		if mg:GetCount()>0 then
			Duel.SendtoGrave(mg,REASON_RULE)
		end
		Duel.Overlay(c,g)
		Duel.Recover(tp,700,REASON_EFFECT)
	end
end
function c65846675.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsCode(65846670)
end
function c65846675.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 7
	else return lv end
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,65846670) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Recover(tp,1000,REASON_EFFECT)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end