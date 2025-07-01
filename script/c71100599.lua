--演奏吧，侵蚀乐园的赋格
function c71100599.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71100599)
	e1:SetCondition(c71100599.condtion)
	e1:SetTarget(c71100599.target)
	e1:SetOperation(c71100599.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN) 
	c:RegisterEffect(e2) 
	--des
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL) 
	e2:SetCountLimit(1,11100599)
	e2:SetCondition(c71100599.descon) 
	e2:SetTarget(c71100599.destg) 
	e2:SetOperation(c71100599.desop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_LEAVE_GRAVE) 
	c:RegisterEffect(e3) 
end
function c71100599.condtion(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp  
end 
function c71100599.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end
function c71100599.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0x7d0,0x7d1) end) 
	e1:SetOwnerPlayer(tp) 
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end)
	e1:SetReset(RESET_CHAIN) 
	Duel.RegisterEffect(e1,tp) 
end
function c71100599.dckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp  
end  
function c71100599.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and eg:IsExists(c71100599.dckfil,1,nil,tp)  
end 
function c71100599.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c71100599.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then 
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)   
	end  
end 





 