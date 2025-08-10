--核心列车 粒子崩坏
c9879216.hxlc=true
function c9879216.initial_effect(c)
	aux.AddXyzProcedure(c,c9879216.mfilter,12,3)
	c:EnableReviveLimit() 

	 local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,9879216)
	e3:SetTarget(c9879216.target)
	e3:SetOperation(c9879216.activate)
	c:RegisterEffect(e3)

	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879216,2))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,1879216)
	e12:SetCost(c9879216.negcost)
	e12:SetTarget(c9879216.sptg) 
	e12:SetOperation(c9879216.spop)  
	c:RegisterEffect(e12)
	
end
function c9879216.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end 
function c9879216.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end
function c9879216.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end


function c9879216.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end 
function c9879216.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9879216.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879216.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA) 
end 
function c9879216.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879216.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOperation(c9879216.retop)
		tc:RegisterEffect(e2)
	end 
end 
function c9879216.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end