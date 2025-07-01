--次生代化石骑兵 骷髅征服者
function c10701470.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10701470.matfilter,aux.FilterBoolFunction(Card.IsLevel,0),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10701470.splimit)
	c:RegisterEffect(e1)	
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c10701470.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--destroy and spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1,10701470)
	e4:SetTarget(c10701470.target)
	e4:SetOperation(c10701470.operation)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
end
function c10701470.matfilter(c,fc)
	return c:IsRace(RACE_ROCK) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(fc:GetControler())
end
function c10701470.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(59419719) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c10701470.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK)
end
function c10701470.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10701470.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*300
end
function c10701470.tgfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,59419719)
end
function c10701470.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
		and Duel.IsExistingTarget(c10701470.tgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c10701470.tgfilter,tp,LOCATION_REMOVED,0,1,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,g2:GetCount(),0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c10701470.filter(c,loc,e)
	return c:IsLocation(loc) and c:IsRelateToEffect(e)
end
function c10701470.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg1=g:Filter(c10701470.filter,nil,LOCATION_ONFIELD,e)
	local tg2=g:Filter(c10701470.filter,nil,LOCATION_REMOVED,e)
	if Duel.Destroy(tg1,REASON_EFFECT)>0 then
		Duel.SendtoGrave(tg2,REASON_EFFECT+REASON_RETURN)
	end
end