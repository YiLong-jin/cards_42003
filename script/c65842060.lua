--玄天之士 江城
function c65842060.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65842060,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,65842060+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65842060.spcon)
	e1:SetTarget(c65842060.sptg)
	e1:SetOperation(c65842060.spop)
	--c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65842060.target)
	e2:SetOperation(c65842060.operation)
	c:RegisterEffect(e2)
end
function c65842060.cfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_WYRM)
end
function c65842060.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65842060.cfilter,tp,LOCATION_EXTRA,0,1,nil,tp)
end
function c65842060.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c65842060.cfilter,tp,LOCATION_EXTRA,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c65842060.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end
function c65842060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2= not e:GetHandler():IsType(TYPE_TUNER)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65842060,1),aux.Stringid(65842060,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(65842060,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(65842060,2))+1
	end
	e:SetLabel(op)
end
function c65842060.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if not c:IsRelateToChain() or c:IsFacedown() then return end
		local down=c:IsLevelAbove(2)
		local lv=aux.SelectFromOptions(tp,{true,aux.Stringid(65842060,3)},{down,aux.Stringid(65842060,4),-1})
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	else
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(TYPE_TUNER)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
end