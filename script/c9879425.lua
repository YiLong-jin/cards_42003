--一番合戦初命·舞武者
function c9879425.initial_effect(c)
	aux.AddCodeList(c,9879421)
	c:EnableCounterPermit(0x7e2)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e0:SetValue(1500)
	c:RegisterEffect(e0)
  
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=3 end)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)

	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e3:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=5 end)
	c:RegisterEffect(e3)


	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_SINGLE)
	e31:SetCode(EFFECT_EXTRA_ATTACK)
	e31:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=7 end)
	e31:SetValue(1)
	c:RegisterEffect(e31) 
	
	 local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(9879425,0))
	e23:SetCategory(CATEGORY_POSITION)
	e23:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e23:SetRange(LOCATION_MZONE)
	e23:SetCode(PHASE_BATTLE+EVENT_PHASE)
	e23:SetHintTiming(TIMING_BATTLE_END)
	e23:SetCondition(c9879425.poscon)
	e23:SetOperation(c9879425.posop)
	c:RegisterEffect(e23)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=14 end)
	e5:SetValue(c9879425.efilter)
	c:RegisterEffect(e5)


	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(9879425,0))
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e21:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCountLimit(1,9879425)
	e21:SetTarget(c9879425.thtg)
	e21:SetOperation(c9879425.thop)
	c:RegisterEffect(e21)
end

function c9879425.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function c9879425.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttackPos() and e:GetHandler():GetCounter(0x7e2)>=7
end
function c9879425.posop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end

function c9879425.thfilter(c)
	return aux.IsCodeListed(c,9879421)  and c:IsAbleToHand()
end
function c9879425.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879425.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879425.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879425.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end