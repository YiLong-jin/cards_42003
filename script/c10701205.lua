--盟军前线
function c10701205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)--+LOCATION_HAND)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	local e2g=e2:Clone()
	e2g:SetTargetRange(0,LOCATION_GRAVE)
	e2g:SetCondition(c10701205.gravecon)
	--c:RegisterEffect(e2g) 
	--special summon 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701205,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c10701205.spcon)
	e3:SetTarget(c10701205.sptg)
	e3:SetOperation(c10701205.spop)
	c:RegisterEffect(e3) 
end
function c10701205.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function c10701205.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	return c:IsReason(REASON_COST) and rc:IsSetCard(0x1) and c:IsControler(tp) and c:IsSetCard(0x1) and c:IsType(TYPE_MONSTER)
end
function c10701205.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701205.cfilter,1,nil,e,tp)
end
function c10701205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(c10701205.cfilter,1,nil,e,tp) end
	local g=eg:Filter(c10701205.cfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function c10701205.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e,tp)
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	   if ft>0 and g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		  if g:GetCount()>ft then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			  rg=g:Select(tp,1,ft,nil)
		  end
		  local tc=rg:GetFirst()
		  while tc do
			  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetCode(EFFECT_CANNOT_TRIGGER)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			  tc:RegisterEffect(e1)
			  tc=rg:GetNext()
		  end
	   end
	   Duel.SpecialSummonComplete()
end
