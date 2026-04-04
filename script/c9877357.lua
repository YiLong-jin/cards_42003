--领地争夺
function c9877357.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,9877357+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c9877357.condition)
	e1:SetTarget(c9877357.target)
	e1:SetOperation(c9877357.activate)
	c:RegisterEffect(e1)
end 
function c9877357.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsLevelAbove(8) and c:IsSetCard(0x27e4) end,tp,LOCATION_MZONE,0,1,nil) 
end
function c9877357.filter(c,e,tp)
	return c:IsSetCard(0x27e4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877357.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9877357.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9877357.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9877357.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
		local dg=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsLevelBelow(7) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
		if dg:GetCount()>0 then 
			Duel.Destroy(dg,REASON_EFFECT)   
		end 
	end
end




