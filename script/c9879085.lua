--芳香护盾·堕香之力
function c9879085.initial_effect(c)
	c:SetUniqueOnField(1,0,9879085)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c9879085.damcon)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9879085.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)

	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c9879085.damcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc9))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c9879085.damcon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x17ea))
	e4:SetValue(1)
	c:RegisterEffect(e4)

	
	local e14=Effect.CreateEffect(c) 
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e14:SetCode(EVENT_SUMMON_SUCCESS) 
	e14:SetRange(LOCATION_SZONE)
	e14:SetCondition(c9879085.reccon) 
	e14:SetOperation(c9879085.recop)  
	c:RegisterEffect(e14)  
	local e15=e14:Clone() 
	e15:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e15)
	
end
function c9879085.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9879085.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end


function c9879085.rckfil(c,e,tp) 
	return (c:IsSetCard(0x17ea) or c:IsSetCard(0xc9)) and c:IsSummonPlayer(tp) and c:IsLevelAbove(1) 
end 
function c9879085.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(c9879085.rckfil,nil,e,tp):GetCount()>0   
end 
function c9879085.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,9879085)
	local ag=eg:Filter(c9879085.rckfil,nil,e,tp) 
	local lv=ag:GetSum(Card.GetLevel) 
	Duel.Recover(tp,lv*50,REASON_EFFECT) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRace(RACE_PLANT) end,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(lv*50/2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext()  
		end 
	end 
end 