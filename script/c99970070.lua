--Savior Of Enlightenment
local m=99970070
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,cm.fusfilter1,cm.fusfilter2)

	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)


end
function cm.cfilter(c,e,tp,sg)
	return c:IsType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,5,nil,e,tp)
	Duel.ConfirmCards(1-tp,g1)
	local pg=e:SetLabelObject(g1)
end
function cm.thfilter(c)
	return c:IsSetCard(0x1661) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,5,nil,e,tp)
	Duel.ConfirmCards(1-tp,g1)
	if c:IsRelateToEffect(e) then
		local tc1=Duel.Destroy(c,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc2=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	if tc2>0 and tc1>0 and g1:GetCount()>0 then
	for tc in aux.Next(g1) do 
	--change name
	local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED )
	e2:SetValue(9991110)
	tc:RegisterEffect(e2)
	end
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.sumcon)
	e1:SetOperation(cm.sumsuc)
	Duel.RegisterEffect(e1,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)

	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.eftg1)
	e4:SetValue(1000)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.eftg1)
	e5:SetValue(1000)
	Duel.RegisterEffect(e5,tp)
		end
		end
	end
end
function cm.eftg1(e,c)
	return c:IsSetCard(0x669) or c:IsSetCard(0x1661)
end
function cm.cfilter11(c)
	return c:IsSetCard(0x669) or c:IsSetCard(0x1661)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter11,1,nil)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(cm.efun)
end
function cm.efun(e,ep,tp)
	return ep==tp
end














function cm.fusfilter1(c)
	return c:IsSetCard(0x1661)
end
function cm.fusfilter2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsSetCard(0x669)
end
