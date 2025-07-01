--次元回探机
local m=30003030
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()  
	--open
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_REMOVED,0,nil)
		if chk==0 then return e:GetHandler():IsAbleToExtra() and mg:GetCount()>=3 end
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then
			local mg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_REMOVED,0,nil)
			local g=mg:Select(tp,3,3,nil)
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==3 then
				Duel.BreakEffect()
				Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
			end
		end
	end)
	c:RegisterEffect(e2)
end
function cm.check(c)
	return c:IsAbleToDeck() 
end