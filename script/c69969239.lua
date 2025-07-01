--交响曲·四季·夏
function c69969239.initial_effect(c)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969239,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,69969239)
	e3:SetCost(c69969239.nacost)
	e3:SetTarget(c69969239.sptg)
	e3:SetOperation(c69969239.spop)
	c:RegisterEffect(e3)  
	local e2=e3:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969239,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c69969239.addct)
	e1:SetOperation(c69969239.addc)
	c:RegisterEffect(e1)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(800)
	e4:SetCondition(c69969239.rmcon)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetCondition(c69969239.indcon)
	c:RegisterEffect(e5)
local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(69969239,2))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e6:SetCountLimit(1,69969247)
	e6:SetCost(c69969239.thcost)
	e6:SetTarget(c69969239.thtg)
	e6:SetOperation(c69969239.thop)
	c:RegisterEffect(e6)
end
function c69969239.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x169b,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x169b,2,REASON_COST)
end
function c69969239.desfilter(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c69969239.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969239.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
  if tc:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(69969239,3)) then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
--2
function c69969239.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x169b)
end
function c69969239.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x169b,2)
	end
end
function c69969239.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x169b)>0
end
function c69969239.indcon(e)
return e:GetHandler():GetCounter(0x169b)>0
end
--3
function c69969239.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and ((e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_SZONE)) or (e:GetHandler():IsLocation(LOCATION_HAND))) end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c69969239.thfilter(c)
	return c:IsSetCard(0x669b) and c:IsAbleToHand() and not c:IsCode(69969239)
end
function c69969239.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69969239.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69969239.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c69969239.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c69969239.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
