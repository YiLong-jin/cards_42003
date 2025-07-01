--准执柄者-辛克莱
function c10000145.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xafe3) end)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
	return c:IsSetCard(0xafe3) and c~=e:GetHandler() end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)
	return c:IsSetCard(0xafe3) and c~=e:GetHandler() end)
	e1:SetValue(function(e,c) 
	return c:GetAttack()+800 end)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(10000145,1)) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10000145)   
	e2:SetTarget(c10000145.atktg)
	e2:SetOperation(c10000145.atkop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(10000145,2)) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,20000145) 
	e3:SetCost(c10000145.spcost)
	e3:SetTarget(c10000145.sptg)
	e3:SetOperation(c10000145.spop)
	c:RegisterEffect(e3)
end 
function c10000145.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end 
end 
function c10000145.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler()) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(-800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN) 
			tc:RegisterEffect(e1)
			tc=g:GetNext() 
		end 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c:GetAttack()*2) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN) 
			c:RegisterEffect(e1)  
			if Duel.GetLP(tp)<=3000 then 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_IMMUNE_EFFECT) 
				e1:SetRange(LOCATION_MZONE)
				e1:SetOwnerPlayer(tp)
				e1:SetValue(function(e,te) 
				return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN) 
				c:RegisterEffect(e1) 
			end 
		end 
	end  
end 
function c10000145.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end
function c10000145.spfilter(c,e,tp)
	return c:IsSetCard(0xafe3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10000145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10000145.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10000145.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10000145.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end

