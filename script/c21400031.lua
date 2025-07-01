--恐虐寻血猎犬
function c21400031.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,21400031)
	e1:SetCondition(c21400031.spcon)
	e1:SetTarget(c21400031.sptg)
	e1:SetOperation(c21400031.spop)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,11400031)
	e2:SetCondition(c21400031.hspcon)
	e2:SetTarget(c21400031.hsptg)
	e2:SetOperation(c21400031.hspop)
	c:RegisterEffect(e2)
	if not c21400031.global_check then
		c21400031.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21400031.checkop)
		Duel.RegisterEffect(ge1,0)  
	end   
end
function c21400031.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler() 
	if tc:IsSetCard(0x6210) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,21400031,RESET_PHASE+PHASE_END,0,1) 
	end
end
function c21400031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x6210) and e:GetHandler():IsReason(REASON_EFFECT) 
end
function c21400031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c21400031.spfil(c,e,tp) 
	return c:IsCode(21400031) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c21400031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsExistingMatchingCard(c21400031.spfil,tp,LOCATION_DECK,0,2,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(21400031,0)) then
			local sg=Duel.SelectMatchingCard(tp,c21400031.spfil,tp,LOCATION_DECK,0,2,2,nil,e,tp)  
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
			local tc=sg:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(1) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1) 
			tc=sg:GetNext() 
			end 
		end 
	end
end
function c21400031.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,21400031)~=0 
end
function c21400031.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400031.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end



