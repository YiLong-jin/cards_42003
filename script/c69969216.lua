--交响的序曲·伏击
function c69969216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_RELEASE) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,69969216)
	e1:SetTarget(c69969216.actg) 
	e1:SetOperation(c69969216.acop) 
	c:RegisterEffect(e1) 
end
function c69969216.ckfil(c,e,tp) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReason(REASON_COST) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0x69b) and Duel.IsExistingMatchingCard(c69969216.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,c)   
end
function c69969216.spfil(c,e,tp,sc)  
	local att=sc:GetAttribute()
	return not c:IsAttribute(att) and c:IsSetCard(0x69b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c69969216.setfil(c) 
	return c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsSetCard(0x69b)   
end 
function c69969216.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c69969216.ckfil,1,nil,e,tp) and re and re:IsActiveType(TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c69969216.setfil,tp,LOCATION_DECK,0,1,nil) end 
	local g=eg:FilterSelect(tp,c69969216.ckfil,1,1,nil,e,tp)  
	Duel.SetTargetCard(g) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c69969216.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if tc and Duel.IsExistingMatchingCard(c69969216.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,tc) then 
		local sg=Duel.SelectMatchingCard(tp,c69969216.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc) 
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c69969216.setfil,tp,LOCATION_DECK,0,1,nil) then 
			local sc=Duel.SelectMatchingCard(tp,c69969216.setfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()  
			Duel.SSet(tp,sc)
		end   
	end 
end 





