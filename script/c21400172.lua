--骑士道
function c21400172.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400172)
	e1:SetTarget(c21400172.target1)
	e1:SetOperation(c21400172.activate1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_SZONE) 
	e1:SetTarget(c21400172.target2)
	e1:SetOperation(c21400172.activate2)
	c:RegisterEffect(e1)
end
function c21400172.target1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c21400172.activate1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then 
		c:CancelToGrave()
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then  
			local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
			Duel.Draw(tp,d,REASON_EFFECT)		
		end 
	end  
end
function c21400172.target2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x5211) end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c21400172.activate2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x5211) end,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK)   
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(10) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	tc=g:GetNext()
	end 
end 


