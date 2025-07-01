--魂魄六剑
function c65846919.initial_effect(c)
	aux.AddCodeList(c,65846916)
	local e1=Effect.CreateEffect(c)----{同调效果}
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65846919.sctg)
	e1:SetOperation(c65846919.scop)
	c:RegisterEffect(e1)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846919,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65846919)
	e2:SetCondition(c65846919.setcon)
	e2:SetTarget(c65846919.settg)
	e2:SetOperation(c65846919.setop)
	c:RegisterEffect(e2)]]
	local e2=Effect.CreateEffect(c)--[[回手效果]]
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65846919)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65846919.thtg)
	e2:SetOperation(c65846919.thop)
	c:RegisterEffect(e2)
end
----{同调召唤-处理}
function c65846919.scfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg)
end
function c65846919.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(0x10) and c:IsType(0x1) end,tp,0x04,0x04,nil)
		return Duel.IsExistingMatchingCard(c65846919.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65846919.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(0x10) and c:IsType(0x1) end,tp,0x04,0x04,nil)
	local g=Duel.GetMatchingGroup(c65846919.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
----{回手效果-处理}
function c65846919.thfilter(c)
	return (aux.IsCodeListed(c,65846916) or c:IsType(TYPE_FIELD)) and c:IsAbleToHand()
end
function c65846919.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846919.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846919.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c65846919.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65846919.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--[[function c65846919.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsCode(65846916)
end
function c65846919.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c65846919.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end]]