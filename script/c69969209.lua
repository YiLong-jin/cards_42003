--交响曲·波来罗
function c69969209.initial_effect(c)
	c:EnableReviveLimit()
	--public
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(69969209,1))
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,69969209)
	e1:SetCondition(c69969209.spcon1)
	e1:SetTarget(c69969209.pbtg) 
	e1:SetOperation(c69969209.pbop)  
	c:RegisterEffect(e1)
	--draw and to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(69969209,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,69969221) 
	e2:SetCondition(c69969209.dtdcon)
	e2:SetTarget(c69969209.dtdtg) 
	e2:SetOperation(c69969209.dtdop) 
	c:RegisterEffect(e2) 
local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c69969209.spcon2)
	c:RegisterEffect(e3)
local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c69969209.dtdcon2)
	c:RegisterEffect(e4)
end
function c69969209.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,69969252)
end
function c69969209.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,69969252)
end
function c69969209.pbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
end 
function c69969209.pbop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969209,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,5) 
	e1:SetLabelObject(e:GetLabelObject()) 
	e1:SetCondition(c69969209.spcon)
	e1:SetOperation(c69969209.spop)
	e1:SetLabel(0)
	c:RegisterEffect(e1) 
	c69969209[c]=e1 
	c:RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,5,0,aux.Stringid(69969209,0)) 
end 
function c69969209.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end
function c69969209.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ct=e:GetLabel()
	c:SetTurnCounter(ct+1) 
	if ct+1==5 then 
	--des
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetTarget(c69969209.destg) 
	e3:SetOperation(c69969209.desop)
	e3:SetReset(RESET_EVENT+0xff0000) 
	c:RegisterEffect(e3) 
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP) 
	else e:SetLabel(ct+1) end
end
function c69969209.dtdcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return c:IsPublic() and c:GetFlagEffect(1082946)~=0 and not Duel.IsPlayerAffectedByEffect(tp,69969252)
end 
function c69969209.dtdcon2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	return c:IsPublic() and c:GetFlagEffect(1082946)~=0 and Duel.IsPlayerAffectedByEffect(tp,69969252)
end 
function c69969209.dtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND) 
end 
function c69969209.dtdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then 
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 
function c69969209.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end 
function c69969209.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD) 
	if g:GetCount()>0 then 
		local x=Duel.Destroy(g,REASON_EFFECT) 
		if x>0 and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(300*x) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		end 
	end 
end 












