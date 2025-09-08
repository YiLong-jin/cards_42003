--与恐虐的约会
function c21400106.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c21400106.mfilter,8,2,c21400106.ovfilter,aux.Stringid(21400106,0),3,c21400106.xyzop)
	c:EnableReviveLimit()   
	--mt at 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400106,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21400106)
	e1:SetCondition(c21400106.ctcon)
	e1:SetTarget(c21400106.cttg)
	e1:SetOperation(c21400106.ctop)
	c:RegisterEffect(e1)
	--destroy all
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11400106)
	e2:SetCost(c21400106.descost)
	e2:SetTarget(c21400106.destg)
	e2:SetOperation(c21400106.desop)
	c:RegisterEffect(e2)
	--tohand
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,31400106)
	e2:SetCondition(c21400106.thcon)
	e2:SetTarget(c21400106.thtg)
	e2:SetOperation(c21400106.thop)
	c:RegisterEffect(e2)
end
function c21400106.mfilter(c)
	return c:IsSetCard(0x6210) 
end
function c21400106.ovfilter(c)
	return c:IsFaceup() and c:IsCode(21400034)
end
function c21400106.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21400106)==0 end
	Duel.RegisterFlagEffect(tp,21400106,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c21400106.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21400106.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local ct=e:GetHandler():RemoveOverlayCard(tp,1,99,REASON_COST)
	e:SetLabel(ct) 
end
function c21400106.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		--multi attack
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(e:GetLabel()-1) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2) 
	end
end
function c21400106.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,8000) end 
	Duel.PayLPCost(tp,8000)
end 
function c21400106.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c21400106.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21400106.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)))
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c21400106.thfilter(c)
	return c:IsSetCard(0x6210) and c:IsAbleToHand()
end
function c21400106.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400106.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21400106.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400106.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




