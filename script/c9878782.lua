--被捕入笼中的鸟
local m=9878782
local cm=_G["c"..m]
function c9878782.initial_effect(c)
	aux.AddCodeList(c,9877881,9877877)

	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)   
	c:RegisterEffect(e0) 

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9878782.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function c9878782.filter(c)
	return c:IsCode(9877881) and c:IsFaceup()
end
function c9878782.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9878782.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9877877) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end
