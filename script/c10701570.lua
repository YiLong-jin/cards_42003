--速攻射手
function c10701570.initial_effect(c)
	aux.AddMaterialCodeList(c,20932152)
	--synchro summon
	aux.AddSynchroProcedure(c,c10701570.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701570,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10701570)
	e2:SetCost(c10701570.cost)
	e2:SetOperation(c10701570.operation)
	c:RegisterEffect(e2)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701570,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10701571)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetTarget(c10701570.destg)
	e3:SetOperation(c10701570.desop)
	c:RegisterEffect(e3)   
end
c10701570.material_setcode=0x1017
function c10701570.tfilter(c)
	return c:IsCode(20932152) or c:IsHasEffect(20932152)
end
function c10701570.filter(c)
	return aux.IsMaterialListSetCard(c,0x1017) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(10701570) and c:IsAbleToGraveAsCost()
end
function c10701570.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10701570)==0
		and Duel.IsExistingMatchingCard(c10701570.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701570.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local code=g:GetFirst():GetOriginalCode()
	e:SetLabel(code)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(10701570,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c10701570.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701570,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetLabel(cid)
	e2:SetLabelObject(e1)
	e2:SetOperation(c10701570.rstop)
	c:RegisterEffect(e2)
end
function c10701570.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10701570.desfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c10701570.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c10701570.tgfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x1017) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function c10701570.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10701570.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10701570.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10701570.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10701570.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c10701570.tgfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
		local gc=g:GetFirst()
		if gc and Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end