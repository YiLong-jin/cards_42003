--魔导召灵-美杜莎
function c9877589.initial_effect(c)
	aux.AddCodeList(c,9877585)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9877589+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9877589.sprcon)
	c:RegisterEffect(e1)


	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877589,0))
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,1877589)
	e11:SetTarget(c9877589.target)
	e11:SetOperation(c9877589.activate)
	c:RegisterEffect(e11)

end
function c9877589.sprfilter(c)
	return c:IsFaceup() and c:IsCode(9877585)
end
function c9877589.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9877589.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end



function c9877589.filter(c,tp,ft)
	if c:IsFacedown() then return false end
	local p=c:GetOwner()
	if p~=tp then ft=0 end
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(p) then r=LOCATION_REASON_CONTROL end
	return Duel.GetLocationCount(p,LOCATION_SZONE,tp,r)>ft
end
function c9877589.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9877589.filter(chkc,tp,0) end
	if chk==0 then
		local ft=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsLocation(LOCATION_HAND) and 1 or 0
		return Duel.IsExistingTarget(c9877589.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9877589.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,0)
end
function c9877589.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
