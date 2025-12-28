--小阿卡那的星币 街舞
function c65846956.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65846956.mat,1,1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CUSTOM+65846956)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1)
	e0:SetLabelObject(e0)
	e0:SetCondition(c65846956.matcon)
	e0:SetTarget(c65846956.mattg)
	e0:SetOperation(c65846956.matop)
	c:RegisterEffect(e0)
	aux.RegisterMergedDelayedEvent(c,65846956,EVENT_SPSUMMON_SUCCESS)
end
function c65846956.mat(c)
	return c:IsSetCard(0x23e0) and not c:IsLinkType(TYPE_LINK)
end
function c65846956.cfilter(c,e,se)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e) and (se==nil or c:GetReasonEffect()~=se)
end
function c65846956.matcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c65846956.cfilter,1,nil,e,se)
end
function c65846956.tgfilter(c,eg,tp)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65846956.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65846956.tgfilter(chkc,eg,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846956.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg,tp)
		and e:GetHandler():IsCanOverlay() and Duel.GetFlagEffect(tp,65846956)==0 end
		Duel.RegisterFlagEffect(tp,65846956,RESET_PHASE+PHASE_END,0,1)
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c65846956.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,eg,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c65846956.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
