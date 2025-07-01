--锡之魔法阵
function c10701499.initial_effect(c)
	aux.AddCodeList(c,10701151)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701499+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701499.sptg)
	e1:SetOperation(c10701499.spop)
	c:RegisterEffect(e1)
	--Destroy 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701499,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c10701499.thcon)
	e2:SetTarget(c10701499.thtg)
	e2:SetOperation(c10701499.thop)
	c:RegisterEffect(e2)
end
function c10701499.spfilter(c,e,tp)
	return (c:IsCode(10701167) or (c:IsSetCard(0x7c3) and c:IsLocation(LOCATION_HAND+LOCATION_REMOVED))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701499.filter(c)
	return c:IsCode(10701151) and c:IsFaceup()
end
function c10701499.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND+LOCATION_REMOVED 
		if Duel.IsExistingMatchingCard(c10701499.filter,tp,LOCATION_SZONE,0,1,nil) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c10701499.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK)
end
function c10701499.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_REMOVED 
	if Duel.IsExistingMatchingCard(c10701499.filter,tp,LOCATION_SZONE,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701499.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701499.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsCode(10701167)
end
function c10701499.thfilter(c)  
	return aux.IsCodeListed(c,10701151) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end  
function c10701499.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c10701499.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.GetFlagEffect(tp,10701499)==0 end 
	Duel.RegisterFlagEffect(tp,10701499,RESET_CHAIN,0,1)  
end  
function c10701499.thop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler()) 
	e2:SetDescription(aux.Stringid(10701499,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e2:SetCountLimit(1)   
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)  
	e2:SetCondition(c10701499.decon)
	e2:SetOperation(c10701499.deop2)  
	Duel.RegisterEffect(e2,tp)  
end
function c10701499.decon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end 
function c10701499.deop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c10701499.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,2,nil)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_CARD,1-tp,10701499)
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end 