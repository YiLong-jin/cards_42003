--玛格特防御立场
local m=9875440
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) 
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	if chk==0 then return #g>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
	if #g==0 then return end
	if ct==0 then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
		for tc in aux.Next(g) do
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetValue(cm.efilter)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)  
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		end  
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if not tc then return end
		Duel.HintSelection(tg)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetValue(cm.efilter)
		e4:SetOwnerPlayer(tp)
		tc:RegisterEffect(e4)  
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
