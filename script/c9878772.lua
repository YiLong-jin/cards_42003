--二叶莎奈
local s,id,o=GetID()
function c9878772.initial_effect(c)
	aux.AddCodeList(c,9877913)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9878772.ffilter,3,true)

	aux.EnableChangeCode(c,9877913,LOCATION_MZONE+LOCATION_GRAVE)
	

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9878772.efilter)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c9878772.etarget)
	c:RegisterEffect(e2)


	local e11=Effect.CreateEffect(c)  
	e11:SetDescription(aux.Stringid(9877635,1))  
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_CHAINING)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,id+o) 
	e11:SetCondition(s.descon)
	e11:SetTarget(s.settg)  
	e11:SetOperation(s.setop)  
	c:RegisterEffect(e11)  
end
function c9878772.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877913) 
end 
function c9878772.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c9878772.etarget(e,c)
	return c:GetType(TYPE_TRAP) and aux.IsCodeListed(c,9877913) 
end


function s.setfilter(c)  
	return c:GetType()==TYPE_TRAP and c:IsSSetable() and c:IsFaceup()
end  
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
end  
function s.setop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
	   Duel.SSet(tp,tc)
	end  
end  