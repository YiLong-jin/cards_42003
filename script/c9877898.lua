--水波玲奈-异时间线
function c9877898.initial_effect(c)
	aux.AddCodeList(c,9877895,9877896,9877897)
	
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877898)
	e1:SetCondition(c9877898.spcon)
	e1:SetTarget(c9877898.sptg)
	e1:SetOperation(c9877898.spop)
	c:RegisterEffect(e1)

	 local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,1877898)
	e2:SetCondition(c9877898.xspcon)
	e2:SetTarget(c9877898.xsptg)
	e2:SetOperation(c9877898.xspop)
	c:RegisterEffect(e2)  
end
function c9877898.f(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) )
end
function c9877898.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9877898.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9877898.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877898.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end


function c9877898.xspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c9877898.xsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE) 
end  
function c9877898.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		c:RegisterEffect(e1)
	end  
end 



