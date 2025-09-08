--魔石神兽 银铁狼
function c9879261.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),aux.NonTuner(c9879261.sfilter),1,1)
	c:EnableReviveLimit()
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9879261.discon)
	e2:SetOperation(c9879261.disop)
	c:RegisterEffect(e2)
	

	 local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879261,0))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,9879261)
	e12:SetCondition(c9879261.damcon)
	e12:SetOperation(c9879261.thop)
	c:RegisterEffect(e12)
	

	 local e13=Effect.CreateEffect(c) 
	e13:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e13:SetType(EFFECT_TYPE_IGNITION)  
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_GRAVE) 
	e13:SetCountLimit(1,1879261) 
	e13:SetTarget(c9879261.dttg) 
	e13:SetOperation(c9879261.dtop) 
	c:RegisterEffect(e13) 
end

function c9879261.sfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and  c:IsRace(RACE_ROCK) and c:IsSynchroType(TYPE_SYNCHRO)
end

function c9879261.lvcon(e)
	return e:GetHandler():GetCounter(0x107e)>0
end
function c9879261.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL+TYPE_TRAP) ) and re:GetHandler():GetCounter(0x107e)>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) 
end
function c9879261.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

function c9879261.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c9879261.thop(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end


function c9879261.desfil(c) 
	return c:IsFaceup() and c:GetCounter(0x107e)>0 
end 
function c9879261.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879261.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)end 
	local g=Duel.SelectTarget(tp,c9879261.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9879261.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end 