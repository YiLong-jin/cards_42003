--无相的十二兽
function c19198131.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c19198131.mfilter,1,1) 
--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198131,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,19198131)
	e1:SetCondition(c19198131.thcon)
	e1:SetTarget(c19198131.thtg)
	e1:SetOperation(c19198131.thop)
	--c:RegisterEffect(e1)   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c19198131.spop)
	c:RegisterEffect(e3)
end
function c19198131.mfilter(c)
	return  c:IsLinkType(TYPE_XYZ) and c:IsSetCard(0xf1)
end
function c19198131.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c19198131.thfilter(c)
	return c:IsSetCard(0xf1) and  c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19198131.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198131.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19198131.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19198131.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c19198131.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c19198131.zonelimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19198131.zonelimit(e)
	return 0x1f001f | (0x600060 & ~0x60)
end