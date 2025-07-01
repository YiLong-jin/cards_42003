--贵光天晶龙 虹镜炎龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,99920050,cm.F,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
--m
function cm.F(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x6661) and c:IsAttribute(ATTRIBUTE_FIRE)
end
--e1
function cm.tgf1(c,tp)
	if not c:IsFaceup() then return false end
	if Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsSetCard,nil,0x6661):GetClassCount(Card.GetAttribute)>1 
		and Duel.GetFlagEffect(tp,m)==0 then return true end
	return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil):Filter(Card.IsSetCard,nil,0x6661):GetClassCount(Card.GetAttribute)>1 
		and Duel.GetFlagEffect(tp,m+1)==0
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(cm.tgf1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SelectTarget(tp,cm.tgf1,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.class(g)
	return g:GetClassCount(Card.GetAttribute)>1 
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsSetCard,nil,0x6661):GetClassCount(Card.GetAttribute)>1 
		and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil):Filter(Card.IsSetCard,nil,0x6661):GetClassCount(Card.GetAttribute)>1 
		and Duel.GetFlagEffect(tp,m+1)==0
	if not (b1 and b2) then return end
	local v={b1 and 1192 or 1191,b1 and b2 and 1191 or nil}
	v=Duel.SelectOption(tp,table.unpack(v))+(not b1 and b2 and 1 or 0)
	if v==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		b1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsSetCard,nil,0x6661):SelectSubGroup(tp,cm.class,false,2,2)
		if b1 and Duel.Remove(b1,POS_FACEUP,REASON_EFFECT)==2 then
			if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		b1=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_REMOVED,0,nil):Filter(Card.IsSetCard,nil,0x6661):SelectSubGroup(tp,cm.class,false,2,2)
		if b1 and Duel.SendtoGrave(b1,REASON_EFFECT+REASON_RETURN)==2 then
			if tc:IsFaceup() and tc:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(-1200)
				tc:RegisterEffect(e1)
			end
		end
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
end