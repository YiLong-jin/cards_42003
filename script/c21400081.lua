--恐虐的荣耀远征
function c21400081.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)	  
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,21400081)
	e1:SetCondition(c21400081.spcon)
	e1:SetTarget(c21400081.sptg)
	e1:SetOperation(c21400081.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400081)
	e2:SetCondition(c21400081.gspcon)
	e2:SetTarget(c21400081.gsptg)
	e2:SetOperation(c21400081.gspop)
	c:RegisterEffect(e2)
end
function c21400081.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x6210) or c:IsType(TYPE_XYZ))
end
function c21400081.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c21400081.cfilter,tp,LOCATION_MZONE,0,nil)==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 
end
function c21400081.spfilter(c,e,tp)
	return c:IsSetCard(0x6210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21400081.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21400081.xyzfil(c,e,tp,tc) 
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x6210) and c:IsRank(tc:GetLevel()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0  
end 
function c21400081.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21400081.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c21400081.xyzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) then
			local sc=Duel.SelectMatchingCard(tp,c21400081.xyzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst() 
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			sc:RegisterFlagEffect(21400081,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCondition(c21400081.descon)
			e1:SetOperation(c21400081.desop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(sc)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c21400081.gspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end 
function c21400081.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21400081.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c21400081.gspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21400081.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end 
	end 
end 
function c21400081.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(21400081)~=0
end
function c21400081.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
