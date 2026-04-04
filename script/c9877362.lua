--灾难等级S-腐朽木龙
function c9877362.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()   
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_SET_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return c:IsLevelBelow(2) or c:IsRankBelow(2) end) 
	e1:SetValue(0) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_SET_DEFENSE) 
	c:RegisterEffect(e2) 
	--xsp
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9877362) 
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	e2:SetTarget(c9877362.xsptg) 
	e2:SetOperation(c9877362.xspop) 
	c:RegisterEffect(e2)
	--to grave and des 
end
function c9877362.tspfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x27e4) 
end 
function c9877362.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877362.tspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c9877362.xspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877362.tspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if x>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877362,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil) 
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end  
end 










