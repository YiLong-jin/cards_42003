--夜王「德古拉的摇篮」
function c8777638.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8777638)
	e1:SetCondition(c8777638.spcon)
	e1:SetTarget(c8777638.target)
	e1:SetOperation(c8777638.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,8777638)
	e2:SetCondition(c8777638.setcon) 
	e2:SetTarget(c8777638.settg)  
	e2:SetOperation(c8777638.setop) 
	c:RegisterEffect(e2) 
end
function c8777638.filter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe)
end
function c8777638.f(c)
	return c:IsFaceup() and c:IsSetCard(0x1ea1)
end
function c8777638.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c8777638.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c8777638.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_FUSION)
	local b2=Duel.IsExistingMatchingCard(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_SYNCHRO)
	local b3=Duel.IsExistingMatchingCard(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_XYZ)
	local b4=Duel.IsExistingMatchingCard(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_LINK)
	local b5=Duel.IsExistingMatchingCard(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_RITUAL)
	local b6=Duel.IsExistingMatchingCard(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,TYPE_PENDULUM)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 or b6 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(8777638,0)
		opval[off-1]=TYPE_FUSION
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(8777638,1)
		opval[off-1]=TYPE_SYNCHRO
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(8777638,2)
		opval[off-1]=TYPE_XYZ
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(8777638,3)
		opval[off-1]=TYPE_LINK
		off=off+1
	end
	if b5 then
		ops[off]=aux.Stringid(8777638,4)
		opval[off-1]=TYPE_RITUAL
		off=off+1
	end
	 if b6 then
		ops[off]=aux.Stringid(8777638,5)
		opval[off-1]=TYPE_PENDULUM
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
end
function c8777638.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c8777638.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	if g:GetCount()>1 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
end


function c8777638.ddckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE)
end 
function c8777638.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c8777638.ddckfil,1,nil,tp)  
end 
function c8777638.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c8777638.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end