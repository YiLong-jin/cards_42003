--龙生九子 邵
function c10000116.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(Card.IsCode,10000108),1,1)
	c:EnableReviveLimit()  
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e2:SetTarget(c10000116.settg) 
	e2:SetOperation(c10000116.setop) 
	c:RegisterEffect(e2) 
	--immuse 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,te) 
	return te:GetOwner():IsType(TYPE_XYZ+TYPE_FUSION+TYPE_PENDULUM+TYPE_LINK) end)  
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10000116,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10000116.discon)
	e4:SetTarget(c10000116.distg)
	e4:SetOperation(c10000116.disop)
	c:RegisterEffect(e4)
	--
end
function c10000116.setfil(c) 
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xafe0) 
end 
function c10000116.sckfil(g,tp) 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()<=Duel.GetLocationCount(tp,LOCATION_SZONE) and g:GetCount()==g:GetClassCount(Card.GetCode)  
end 
function c10000116.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10000116.setfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c10000116.sckfil,1,3,tp) end 
end 
function c10000116.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c10000116.setfil,tp,LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(c10000116.sckfil,1,3,tp) then 
		local sg=g:SelectSubGroup(tp,c10000116.sckfil,false,1,3,tp) 
		Duel.SSet(tp,sg) 
	end  
end 
function c10000116.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10000116.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10000116,3))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10000116.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


