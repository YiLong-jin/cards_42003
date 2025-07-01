--奇术师 情人节兔女郎
function c10700272.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700272,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10700272)
	e1:SetCondition(c10700272.drcon)
	e1:SetTarget(c10700272.drtg)
	e1:SetOperation(c10700272.drop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700272,0))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10700273)
	e2:SetCondition(c10700272.spcon)
	e2:SetTarget(c10700272.sptg)
	e2:SetOperation(c10700272.spop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700272,0))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10700273)
	e3:SetCondition(c10700272.spcon2)
	e3:SetTarget(c10700272.sptg2)
	e3:SetOperation(c10700272.spop2)
	c:RegisterEffect(e3) 
	--spsummon proc
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c10700272.spcon3)
	c:RegisterEffect(e4)	
end
c10700272.toss_coin=true
function c10700272.cfilter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c10700272.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c10700272.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10700272.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c10700272.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10700272.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700272.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c10700272.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) and not Duel.IsPlayerAffectedByEffect(tp,10701040)
end
function c10700272.spfilter(c,e,tp)
	return c.toss_coin and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700272.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10700272.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c10700272.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	  local res=Duel.TossCoin(tp,1)
	  if res==1 then 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,c10700272.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		 local sc=g:GetFirst()
		  if g:GetCount()>0 then
			 if sc then
			  Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			 end
		  end
	  else 
			Duel.NegateRelatedChain(c,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetOwner())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			c:RegisterEffect(e3)
	  end
end
function c10700272.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) and Duel.IsPlayerAffectedByEffect(tp,10701040)
end
function c10700272.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10700272.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c10700272.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	  local c1,c2,c3=Duel.TossCoin(tp,3)
	  if c1+c2+c3>0 then 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		 local g=Duel.SelectMatchingCard(tp,c10700272.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		 local sc=g:GetFirst()
		  if g:GetCount()>0 then
			 if sc then
			  Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			 end
		  end
	  else 
			Duel.NegateRelatedChain(c,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetOwner())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			c:RegisterEffect(e3)
	  end
end