--万圣夜想曲 拜金梦魔
function c10700828.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_HAND)
	e0:SetOperation(c10700828.adjustop)
	c:RegisterEffect(e0)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c10700828.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+10700828)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c10700828.operation)
	c:RegisterEffect(e2) 
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700828,2))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCountLimit(1,10700830)
	e3:SetCondition(c10700828.ctrcon)
	e3:SetCost(c10700828.ctrcost)
	e3:SetTarget(c10700828.ctrtg)
	e3:SetOperation(c10700828.ctrop)
	c:RegisterEffect(e3)
end
function c10700828.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPublic() and c:GetFlagEffect(10700829)==0 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700828,e,0,0,0,0)
		c:RegisterFlagEffect(10700829,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif not c:IsPublic() and c:GetFlagEffect(10700828)>0 then
		c:ResetFlagEffect(10700829)
	end
end
function c10700828.operation(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(10700828,0)
		opval[off-1]=1
		off=off+1
	end
		ops[off]=aux.Stringid(10700828,1)
		opval[off-1]=2
		off=off+1
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		e1:SetValue(2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10700828.ctrcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsFaceup() and e:GetHandler():IsLocation(LOCATION_MZONE)) or (e:GetHandler():IsPublic() and e:GetHandler():IsLocation(LOCATION_HAND))
end
function c10700828.ctrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10700828.ctrfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c10700828.ctrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10700828.ctrfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700828.ctrfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c10700828.ctrfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c10700828.ctrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	  Duel.GetControl(tc,tp,PHASE_END,1)
	end
end