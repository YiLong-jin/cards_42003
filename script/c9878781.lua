--谣言鹤乃-原点觉醒
local cm,m=GetID()

cm.Uwasa=true
function c9878781.initial_effect(c)
	aux.AddCodeList(c,9877877,9877881)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9878781.ffilter,3,true)
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
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9878781) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e3:SetTarget(c9878781.thtg)
	e3:SetOperation(c9878781.thop)
	c:RegisterEffect(e3) 
	

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878781,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1878781)
	e2:SetTarget(c9878781.target)
	e2:SetOperation(c9878781.operation)
	c:RegisterEffect(e2)
end
function c9878781.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877877) 
end 

function c9878781.thfilter(c)
	return aux.IsCodeListed(c,9877877) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9878781.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878781.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9878781.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878781.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c9878781.spfil(c,e,tp)
	return aux.IsCodeListed(c,9877877) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9878781.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9878781.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9878781.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9878781.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end