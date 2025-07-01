--升阶魔法 - 早已无法抵达的理想乡
function c4405659.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c4405659.regcon)
	e1:SetOperation(c4405659.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c4405659.condition)
	e2:SetCost(c4405659.cost)
	e2:SetTarget(c4405659.target)
	e2:SetOperation(c4405659.activate)
	c:RegisterEffect(e2)
end
function c4405659.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,4405659)==0 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function c4405659.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(4405659,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(4405659,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end 
function c4405659.ckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xd77)   
end  
function c4405659.ckgck(g) 
	return g:GetClassCount(Card.GetCode)==g:GetCount()  
end 
function c4405659.condition(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(c4405659.ckfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	return g:CheckSubGroup(c4405659.ckgck,2,2)
end
function c4405659.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(4405659)~=0 end
end 
function c4405659.spfil(c,e,tp)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xd77) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c4405659.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)  
end 
function c4405659.espfil(c,e,tp,mc) 
	return c:IsType(TYPE_XYZ) and c:IsCode(4527659) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and mc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 
end   
function c4405659.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c4405659.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function c4405659.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,4405659)~=0 then return end
	Duel.RegisterFlagEffect(tp,4405659,0,0,0) 
	local g=Duel.GetMatchingGroup(c4405659.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local mc=g:Select(tp,1,1,nil):GetFirst() 
	if Duel.SpecialSummon(mc,0,tp,tp,false,false,POS_FACEUP)~=0 and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL) then  
	local sc=Duel.SelectMatchingCard(tp,c4405659.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc):GetFirst() 
	if sc==nil then return end 
	Duel.BreakEffect()   
	sc:SetMaterial(Group.FromCards(mc))
	Duel.Overlay(sc,mc)
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure() 
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(sc,Group.FromCards(c))
		end
	end 
	end 
end 





