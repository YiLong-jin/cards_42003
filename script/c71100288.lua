--驱动女神信仰水晶
function c71100288.initial_effect(c)
	   --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100288)
	e1:SetTarget(c71100288.target)
	e1:SetOperation(c71100288.activate)
	c:RegisterEffect(e1)
	--giveDamage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,71130288)
	e2:SetCondition(c71100288.dmcon)
	e2:SetTarget(c71100288.dmtg)
	e2:SetOperation(c71100288.dmop)
	c:RegisterEffect(e2)
end
function c71100288.chkfilter(c,tp)
	return c:IsSetCard(0x17df) and not c:IsPublic() and Duel.IsExistingMatchingCard(c71100288.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c71100288.thfilter(c,att)
	return c:IsSetCard(0x17df) and c:IsAttribute(att) and c:IsAbleToHand()
end
function c71100288.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100288.chkfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71100288.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c71100288.chkfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if rc then
		local att=rc:GetAttribute()
		Duel.ConfirmCards(1-tp,rc)
		local g=Duel.SelectMatchingCard(tp,c71100288.thfilter,tp,LOCATION_DECK,0,1,1,nil,att)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c71100288.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE)
end
function c71100288.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,0)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c71100288.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,0)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end
