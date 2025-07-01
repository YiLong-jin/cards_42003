--失乐园 吾的权能尔等拜服
function c10000130.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10000130+EFFECT_COUNT_CODE_OATH) 
	c:RegisterEffect(e1)	
	--xx
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10000130.reptg)
	e2:SetValue(c10000130.repval)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c10000130.damval) 
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xafe2) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
end

function c10000130.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0xafe2) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c10000130.reptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:IsExists(Card.IsAbleToRemove,3,nil,tp) and eg:IsExists(c10000130.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c10000130.repval(e,c)
	return c10000130.repfilter(c,e:GetHandlerPlayer())
end
function c10000130.damval(e,re,val,r,rp,rc)
	if val>=1000 then 
		return 0
	end
	return val
end









