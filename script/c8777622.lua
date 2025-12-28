--碎空一闪
function c8777622.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8777622,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,8777622)
	e1:SetTarget(c8777622.destg)
	e1:SetOperation(c8777622.desop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8777622,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1777622)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c8777622.negcon)
	e2:SetTarget(c8777622.sptg2)
	e2:SetOperation(c8777622.spop2)
	c:RegisterEffect(e2)
end
function c8777622.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x1eaa) and  c:IsType(TYPE_MONSTER)
end 
function c8777622.spfil1(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_ZOMBIE)
end 
function c8777622.filter2(c)
	return c:IsSetCard(0x1eaa) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c8777622.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777622.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
end
function c8777622.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c8777622.spfil1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c8777622.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	if g:GetCount()>0 and Duel.IsExistingMatchingCard(c8777622.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(8777622,1)) then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
	   local sg=g1:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
	end
end


function c8777622.spfilter2(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c8777622.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c8777622.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8777622.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c8777622.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c8777622.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
