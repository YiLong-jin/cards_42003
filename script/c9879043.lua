--共振粒子加速器
function c9879043.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 

	aux.AddCodeList(c,9879042)

	

	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetCountLimit(1,9879043)
	e4:SetTarget(c9879043.xsptg) 
	e4:SetOperation(c9879043.xspop) 
	c:RegisterEffect(e4) 



	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879043,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9879043)
	e2:SetTarget(c9879043.thtg1)
	e2:SetOperation(c9879043.thop1)
	c:RegisterEffect(e2)
end
function c9879043.ctilter1(c,e,tp)
	return  aux.IsCodeListed(c,9879042) and c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9879043.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9879043.thop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9879043.ctilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9879042,2)) then
			local g=Duel.SelectMatchingCard(tp,c9879043.ctilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function c9879043.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and aux.IsCodeListed(c,9879042) and c:IsType(TYPE_MONSTER)
end 
function c9879043.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9879043.xspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end 
function c9879043.xspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c9879043.xspfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end  
end