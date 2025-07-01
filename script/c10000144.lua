--大锤-默尔索
function c10000144.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(10000144,1)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_LEAVE_FIELD) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,20000144)   
	e1:SetCondition(c10000144.spcon) 
	e1:SetTarget(c10000144.sptg)
	e1:SetOperation(c10000144.spop)
	c:RegisterEffect(e1) 
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e2:SetValue(function(e,c)
	return c~=e:GetHandler() end) 
	c:RegisterEffect(e2) 
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(function(e,c)
	return c~=e:GetHandler() end) 
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10000144,2)) 
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10000144)  
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e3:SetCost(c10000144.atkcost)
	e3:SetTarget(c10000144.atktg)
	e3:SetOperation(c10000144.atkop)
	c:RegisterEffect(e3)
end 
function c10000144.sckfil(c,tp) 
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)  
end 
function c10000144.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c10000144.sckfil,1,nil,tp) 
end 
function c10000144.spfilter(c,e,tp)
	return c:IsSetCard(0xafe3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10000144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10000144.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10000144.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10000144.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c10000144.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>=1000 end
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end  
function c10000144.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end 
end 
function c10000144.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,e:GetHandler()) 
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-1000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)
		if g:GetCount()>0 then 
			local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1000) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			tc:RegisterEffect(e1)
			tc=g:GetNext() 
			end 
		end 
	end 
end 



