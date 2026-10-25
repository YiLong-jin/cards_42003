--精灵黑江与神官二叶
local cm,m=GetID()
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c42624999") end) then require("script/c42624999") end

function cm.initial_effect(c)
	aux.AddCodeList(c,9877918,9877913,9877873,9877951)
	aux.AddLinkProcedure(c,cm.lfcheck,2,2)
	c:EnableReviveLimit()

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e2)


	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,1))
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e21:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCountLimit(1,m)
	e21:SetTarget(cm.thtg)
	e21:SetOperation(cm.thop)
	c:RegisterEffect(e21)
end

function cm.lfcheck(c)
	return c:IsLinkRace(RACE_SPELLCASTER)
end

function cm.thfilter(c)
	return c:IsCodeListed(9877918,9877913) and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	e:GetHandler():SPSummonLimit(aux.TargetBoolFunction(aux.NOT(Card.IsCodeListed),9877918,9877913,9877873,9877951),RESET_PHASE+PHASE_END,tp,nil,1,0,nil,2)
end