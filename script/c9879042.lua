--铹机侠
function c9879042.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 

	aux.AddCodeList(c,9879042)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879042,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9879042)
	e3:SetTarget(c9879042.destg)
	e3:SetOperation(c9879042.desop)
	c:RegisterEffect(e3)


	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879042,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9879042)
	e2:SetTarget(c9879042.thtg1)
	e2:SetOperation(c9879042.thop1)
	c:RegisterEffect(e2)
end
function c9879042.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c9879042.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if #dg==0 then return end
	Duel.HintSelection(dg)
	if  Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
	end
end


function c9879042.ctilter1(c,e,tp)
	return  aux.IsCodeListed(c,9879042) and c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9879042.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9879042.thop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9879042.ctilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9879042,2)) then
			local g=Duel.SelectMatchingCard(tp,c9879042.ctilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end