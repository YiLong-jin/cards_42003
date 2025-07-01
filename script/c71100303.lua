--秘源骑兵 萝兰
function c71100303.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum Summon   
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_PZONE) 
	e1:SetCountLimit(1,71100303)  
	e1:SetCondition(c71100303.pscon) 
	e1:SetCost(c71100303.pscost)
	e1:SetTarget(c71100303.pstg) 
	e1:SetOperation(c71100303.psop) 
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(71100303,ACTIVITY_SPSUMMON,c71100303.counterfilter)
	Duel.AddCustomActivityCounter(71100303,ACTIVITY_SUMMON,c71100303.counterfilter)
end
function c71100303.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsSummonLocation(LOCATION_EXTRA)
end
function c71100303.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71100303,tp,ACTIVITY_SPSUMMON)==0  and Duel.GetCustomActivityCount(71100303,tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71100303.splimit)
	Duel.RegisterEffect(e1,tp) 
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c71100303.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK) and not c:IsLocation(LOCATION_EXTRA)
end
function c71100303.pscon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x7de) 
end  
function c71100303.pspfil(c,e,tp,lsc,rsc) 
	local lv=c:GetLevel()
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) 
	and lv>0 and lv>lsc and lv<rsc and c:IsSetCard(0x7de)
end 
function c71100303.spgck(g) 
	return g:GetClassCount(Card.GetCode)==g:GetCount()  
end 
function c71100303.pstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lsc=lc:GetLeftScale()
	local rsc=rc:GetRightScale() 
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if lsc>rsc then lsc,rsc=rsc,lsc end 
	local g=Duel.GetMatchingGroup(c71100303.pspfil,tp,LOCATION_DECK,0,nil,e,tp,lsc,rsc)
	if chk==0 then return ft>0 and lc and rc and g:CheckSubGroup(c71100303.spgck,1,ft) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c71100303.psop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if ft>0 and lc and rc then
	local lsc=lc:GetLeftScale()
	local rsc=rc:GetRightScale()
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local g=Duel.GetMatchingGroup(c71100303.pspfil,tp,LOCATION_DECK,0,nil,e,tp,lsc,rsc)  
	if g:CheckSubGroup(c71100303.spgck,1,ft) then 
	local sg=g:SelectSubGroup(tp,c71100303.spgck,false,1,ft) 
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	end  
	end 
end 




