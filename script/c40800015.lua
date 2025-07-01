--芝士 靛蓝
function c40800015.initial_effect(c)
	aux.AddCodeList(c,40800000)
	aux.AddLinkProcedure(c,nil,2,2,c40800015.lcheck)
	c:EnableReviveLimit()	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40800015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,40800000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c40800015.cost)
	e1:SetTarget(c40800015.sptg)
	e1:SetOperation(c40800015.spop)
	c:RegisterEffect(e1)
	--[[local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(40800015,1))
	e2:SetTarget(c40800015.sptg)
	e2:SetOperation(c40800015.spop)
	c:RegisterEffect(e2)]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c40800015.rmlimit)
	c:RegisterEffect(e4)  
end
c40800015.SetCard_RR_ZS=true 
function c40800015.lcheck(g,lc)
	return g:IsExists(function(c) return c.SetCard_RR_ZS end,1,nil)
end
function c40800015.rmlimit(e,c,tp,r,re) 
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c.SetCard_RR_ZS and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c:IsFaceup() and r&REASON_EFFECT>0
end
function c40800015.costfilter(c)
	return c:IsCode(40800000) and c:IsAbleToExtraAsCost()
end
function c40800015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToExtraAsCost() and c:IsCode(40800000) end,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c40800015.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c40800015.spfilter(c,e,tp)
	return c.SetCard_RR_ZS and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40800015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40800015.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c40800015.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40800015.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end