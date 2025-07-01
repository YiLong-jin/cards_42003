--V城默示录~死者之疮
function c71100565.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71100565+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c71100565.accon) 
	e1:SetTarget(c71100565.actg)
	e1:SetOperation(c71100565.acop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_LEAVE_FIELD)  
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(c71100565.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71100565.sptg)
	e2:SetOperation(c71100565.spop)
	c:RegisterEffect(e2)
end
function c71100565.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) 
end 
function c71100565.setfilter(c)
	return c:IsSetCard(0x7d2) and c:IsSetCard(0x7d7) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c71100565.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100565.setfilter,tp,LOCATION_DECK,0,1,nil) end  
end
function c71100565.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c71100565.setfilter,tp,LOCATION_DECK,0,1,nil) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
		local tc=Duel.SelectMatchingCard(tp,c71100565.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end 
end
function c71100565.sckfil(c,tp)
	return c:IsPreviousSetCard(0x17a2) and c:IsPreviousControler(tp) 
end 
function c71100565.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c71100565.sckfil,1,nil,tp)
end 
function c71100565.spfil(c,e,tp)
	return c:IsSetCard(0x17a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c71100565.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c71100565.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c71100565.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 then
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) 
	end
end






