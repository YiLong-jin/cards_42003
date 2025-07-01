--次元传输机 
local m=30003040
local cm=_G["c"..m]
function cm.initial_effect(c)
   aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,3,cm.lcheck) 
	c:EnableReviveLimit()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_REMOVED,0,nil)
		if chk==0 then return mg:GetCount()>=3 end
		local g=mg:Select(tp,3,3,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_HAND)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then
			if Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
					if g:GetCount()>0 then
					   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
					end
				end  
			end
		end
	end)
	c:RegisterEffect(e2)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsCode,1,nil,30003030)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function cm.check(c)
	return c:IsAbleToDeckOrExtraAsCost() 
end