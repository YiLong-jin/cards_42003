--秘源引导的选择
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL) 
	e1:SetTarget(cm.actg) 
	e1:SetOperation(cm.acop)  
	c:RegisterEffect(e1)
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function cm.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(cm.spcon) 
	e1:SetOperation(cm.thop) 
	e1:SetLabel(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.igcon)
	Duel.RegisterEffect(e2,tp) 
	local e3=e1:Clone()
	e3:SetCode(EVENT_SSET)
	e3:SetCondition(cm.secon)
	Duel.RegisterEffect(e3,tp) 
end 
function cm.thfil(c)
	return c:IsAbleToHand() or c:IsAbleToGrave()
end
function cm.spckfil(c,tp) 
	return c:GetSummonPlayer()==tp and c:IsLevelAbove(5)
end 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local p1,p2=e:GetLabel()
	if p1~=0 and eg:IsExists(cm.spckfil,1,nil,tp) then p1=0 end 
	if p2~=0 and eg:IsExists(cm.spckfil,1,nil,1-tp) then p2=0 end 
	e:SetLabel(p1,p2)
	return p1+p2==0 and Duel.GetDecktopGroup(tp,1):IsExists(cm.thfil,1,nil)
end 
function cm.igcon(e,tp,eg,ep,ev,re,r,rp)  
	if (not re:IsActiveType(TYPE_MONSTER)) or 0==re:GetActivateLocation()&LOCATION_GRAVE then return false end
	local p1,p2=e:GetLabel()
	if p1~=0 and rp==tp then p1=0 end 
	if p2~=0 and rp~=tp then p2=0 end 
	e:SetLabel(p1,p2)
	return p1+p2==0 and Duel.GetDecktopGroup(tp,1):IsExists(cm.thfil,1,nil)
end 
function cm.secon(e,tp,eg,ep,ev,re,r,rp)  
	local p1,p2=e:GetLabel()
	if p1~=0 and rp==tp then p1=0 end 
	if p2~=0 and rp~=tp then p2=0 end 
	e:SetLabel(p1,p2)
	return p1+p2==0 and Duel.GetDecktopGroup(tp,1):IsExists(cm.thfil,1,nil)
end 
function cm.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Hint(HINT_CARD,0,m)
	Duel.ConfirmCards(tp,tc)
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	e:Reset()
end 
