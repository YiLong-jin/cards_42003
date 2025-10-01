--驱动空天的威胁
function c9879271.initial_effect(c)
	aux.AddCodeList(c,9879202)


	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(9879271,1)) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMING_END_PHASE) 
	e1:SetCountLimit(1,9879271+EFFECT_COUNT_CODE_OATH)   
	e1:SetTarget(c9879271.actg2) 
	e1:SetOperation(c9879271.acop2) 
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879271,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1879271)
	e3:SetCondition(c9879271.spcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9879271.sptg)
	e3:SetOperation(c9879271.spop)
	c:RegisterEffect(e3)
	
end
function c9879271.ckfil(c) 
	return c:IsFaceup() and aux.IsCodeListed(c,9879202) 
end 
function c9879271.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879271.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c9879271.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 

function c9879271.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp 
end
function c9879271.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9879202) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879271.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9879271.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9879271.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879271.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end