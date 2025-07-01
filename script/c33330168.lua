--幻想宇宙的帷幕
function c33330168.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330168,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33330168)
	e2:SetTarget(c33330168.tg2)
	e2:SetOperation(c33330168.op2)
	c:RegisterEffect(e2)
--
end
--
function c33330168.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function c33330168.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local fid=e:GetHandler():GetFieldID()
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_1:SetCode(EFFECT_SEND_REPLACE)
			e2_1:SetLabel(fid)
			e2_1:SetTarget(c33330168.tg2_1)
			e2_1:SetValue(c33330168.val2_1)
			e2_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2_1,tp)
			local e2_2=Effect.CreateEffect(e:GetHandler())
			e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_2:SetCode(EVENT_PHASE+PHASE_END)
			e2_2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2_2:SetReset(RESET_PHASE+PHASE_END)
			e2_2:SetCountLimit(1)
			e2_2:SetLabel(fid)
			e2_2:SetCondition(c33330168.con2_2)
			e2_2:SetOperation(c33330168.op2_2)
			Duel.RegisterEffect(e2_2,tp)
		end
	end
end
function c33330168.repfilter2_1(c,tp)
	return c:IsControler(tp) and c:GetDestination()==LOCATION_GRAVE 
		and c:IsAbleToRemove()
end
function c33330168.tg2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33330168.repfilter2_1,1,nil,tp) end
	local fid=e:GetLabel()
	local g=eg:Filter(c33330168.repfilter2_1,nil,tp)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(33330168,RESET_EVENT+0x1f60000+RESET_PHASE+PHASE_END,0,1,fid)
	end
	return true
end
function c33330168.val2_1(e,c)
	return false
end
function c33330168.cfilter2_2(c,fid)
	return c:GetFlagEffectLabel(33330168)==fid and c:IsAbleToGrave()
end
function c33330168.con2_2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	if not g:IsExists(c33330168.cfilter2_2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c33330168.op2_2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	local tg=g:Filter(c33330168.cfilter2_2,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
end
--