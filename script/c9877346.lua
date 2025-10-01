--薇特莉斯甜点工坊-女仆时刻
function c9877346.initial_effect(c)
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c9877346.target)
	c:RegisterEffect(e0)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9877346.etarget)
	e2:SetValue(c9877346.efilter)
	c:RegisterEffect(e2) 

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9877346,2))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_SZONE)
	e12:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e12:SetCountLimit(1,9877346) 
	e12:SetCost(c9877346.negcost)
	e12:SetTarget(c9877346.sptg) 
	e12:SetOperation(c9877346.spop)  
	c:RegisterEffect(e12) 

	
end
function c9877346.etarget(e,c)
	return c:IsSetCard(0x17e4) and c:IsType(TYPE_XYZ)
end
function c9877346.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_LINK) and re:IsActivated()
end


function c9877346.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c9877346.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17e4) and c:IsFaceup()
end 
function c9877346.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877346.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c9877346.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877346.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 


function c9877346.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c9877346.gycon)
	e1:SetOperation(c9877346.gyop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function c9877346.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9877346.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end