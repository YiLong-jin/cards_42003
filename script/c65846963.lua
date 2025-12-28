--小阿卡那的星币 偶像
function c65846963.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65846963.linkff,2,2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,65846963)
	e0:SetTarget(c65846963.settg)
	e0:SetOperation(c65846963.setop)
	c:RegisterEffect(e0)
end
function c65846963.linkff(c)
	return c:IsSetCard(0x23ef)
end
function c65846963.setfilter(c)
	return c:IsSetCard(0x23ef) and c:IsType(0x6) and c:IsSSetable()
end
function c65846963.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846963.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c65846963.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65846963.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(65846963,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e2)
	end
end