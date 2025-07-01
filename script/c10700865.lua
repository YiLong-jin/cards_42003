--灵兽使 诺弥
function c10700865.initial_effect(c)
	c:SetSPSummonOnce(10700865) 
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700865,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c10700865.settg)
	e1:SetOperation(c10700865.setop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	
end
function c10700865.filter(c)
	return c:IsSetCard(0xb5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() 
			and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c10700865.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10700865.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c10700865.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10700865.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		  if tc:IsType(TYPE_QUICKPLAY) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		  end
		  if tc:IsType(TYPE_TRAP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		 end
	end
end