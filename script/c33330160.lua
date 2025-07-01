--巨大贪吃仓鼠
local m=33330160
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		c:CancelToGrave()
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
			c:RegisterEffect(e2)
		--instant(chain)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,2))
			e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetHintTiming(0,TIMING_END_PHASE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetLabel(tc:GetCode())
			e2:SetCountLimit(1)
			e2:SetTarget(cm.sptg2)
			e2:SetOperation(cm.spop2)
			c:RegisterEffect(e2)
	end
end
function cm.filter(c,e,tp,code)
	local rrp=c:GetOwner()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,rrp) and c:IsCode(code)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,code) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local rrp=c:GetOwner()
	if c:IsRelateToEffect(e) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,code)
		Duel.SpecialSummon(tc,0,tp,rrp,false,false,POS_FACEUP) 
		Duel.Destroy(c,REASON_EFFECT)
	end
end