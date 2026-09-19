--感染-蔓延
function c9877373.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,9877373+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c9877373.accost)
	e1:SetTarget(c9877373.actg) 
	e1:SetOperation(c9877373.acop) 
	c:RegisterEffect(e1) 
end
function c9877373.accost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsDestructable() and c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x27e4) end,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsDestructable() and c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x27e4) end,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil) 
	Duel.Destroy(g,REASON_COST) 
end 
function c9877373.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x27e4) and c:IsLevelBelow(4)  
end 
function c9877373.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9877373.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c9877373.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c9877373.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 


