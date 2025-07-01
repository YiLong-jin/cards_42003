--A魔熊花莉莉丝
local m=65846694
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,65846687,65846701,65846687)
	aux.AddFusionProcCode2(c,65846684,65846671,true,true)
	--[[local e0=aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST) 
	e0:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e0)]] 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	aux.EnableChangeCode(c,65846684,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.thtrfah(c,chken)
	return (c:IsCode(65846687) or chken and c:IsCode(65846701)) and c:IsAbleToHand()
end
function cm.thtrfat(c)
	return c:IsCode(65846687) and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chken=Duel.IsExistingMatchingCard(cm.thtrfat,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thtrfah,tp,LOCATION_DECK,0,1,nil,chken) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,rg,ep,ev,re,r,rp)
	local chken=Duel.IsExistingMatchingCard(cm.thtrfat,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thtrfah,tp,LOCATION_DECK,0,1,1,nil,chken)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
