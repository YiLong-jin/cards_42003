--Savior of Truth
local m=99970170
local cm=_G["c"..m]
function cm.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c99970170.mfilter,nil,2,2)
	
	
		--set s/t
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m+10000)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_XYZ_LEVEL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetLabel(3)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetLabel(4)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetLabel(9)
	c:RegisterEffect(e8)
end
function cm.filter(c)
	return (c:IsSetCard(0x671) or c:IsSetCard(0x66c)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end















function c99970170.mfilter(c,xyzc)
	return (c:IsSetCard(0x671) or c:IsSetCard(0x66c) or c:IsSetCard(0x1661))
end
