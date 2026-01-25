--谣言鹤乃-原点突破
local cm,m=GetID()

cm.Uwasa=true
function c9878780.initial_effect(c)
	aux.AddCodeList(c,9877877,9877881)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9878780.ffilter,2,true)
	aux.EnableChangeCode(c,9877881,LOCATION_MZONE+LOCATION_GRAVE)


	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9878780) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e3:SetTarget(c9878780.thtg)
	e3:SetOperation(c9878780.thop)
	c:RegisterEffect(e3) 

	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_BE_MATERIAL)
	e11:SetCountLimit(1,1878780)
	e11:SetCondition(c9878780.thcon)
	e11:SetTarget(c9878780.thtg1)
	e11:SetOperation(c9878780.thop1)

end
function c9878780.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877877) 
end 
function c9878780.thfilter(c)
	return aux.IsCodeListed(c,9877877) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c9878780.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878780.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9878780.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878780.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9878780.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_REDIRECT)
end
function c9878780.thfilter1(c)
	return aux.IsCodeListed(c,9877881) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c9878780.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878780.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9878780.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9878780.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end