--秘源异术 饿鬼缠身
function c71100313.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,71100313+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71100313.actg)
	e1:SetOperation(c71100313.acop) 
	c:RegisterEffect(e1)
	if not c71100313.global_check then
		c71100313.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c71100313.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c71100313.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x7de) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(71100313,RESET_EVENT+RESETS_STANDARD,0,1)
		tc=eg:GetNext()
	end
end
function c71100313.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetFlagEffect(71100313)~=0 end 
end 
function c71100313.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7de))
	e1:SetValue(c71100313.val) 
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp) 
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c71100313.drcon)  
	e2:SetOperation(c71100313.drop)   
	e2:SetLabel(0)
	e2:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e2,tp) 
end 
function c71100313.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c71100313.val(e,c)  
	return Duel.GetMatchingGroupCount(c71100313.filter,c:GetControler(),0,LOCATION_GRAVE+LOCATION_REMOVED,nil)*100
end
function c71100313.ckfil(c,tp) 
	return c:GetReasonPlayer()==1-tp  
end 
function c71100313.drcon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:IsExists(c71100313.ckfil,1,nil,tp)
end 
function c71100313.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	local g=eg:Filter(c71100313.ckfil,nil,tp)
	local x=g:GetCount() 
	local flag=e:GetLabel() 
	if x>0 then flag=flag+x end 
	if flag>=4 then 
	local ct=flag%4
	local dr=(flag-ct)/4
	flag=ct
	Duel.Hint(HINT_CARD,0,71100313)
	Duel.Draw(tp,dr,REASON_EFFECT)   
	end  
	e:SetLabel(flag)	
end 






