--远古海洋底部的火山喷发
local s,id,o=GetID()
function c90306308.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,90306308)
	e1:SetTarget(c90306308.rectg)
	e1:SetOperation(c90306308.recop)
	c:RegisterEffect(e1)
   --change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,90306308)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCondition(c90306308.chcon)
	e4:SetOperation(c90306308.chop)
	c:RegisterEffect(e4)
end
function c90306308.chcon(e,tp,eg,ep,ev,re,r,rp)
	return  re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c90306308.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c90306308.repop)
end
function c90306308.desfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function c90306308.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,90306308)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c90306308.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.filter(c)
	return c:IsSetCard(0x975) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) 
end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end