--永霜零式_莫德雷德
function c71100176.initial_effect(c)
	--overlay
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71100176)
	e1:SetTarget(c71100176.ovtg)
	e1:SetOperation(c71100176.ovop)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c71100176.rmlimit)
	c:RegisterEffect(e2)
end
function c71100176.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7d9) and c:IsType(TYPE_XYZ)
end
function c71100176.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71100176.ovfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71100176.ovfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71100176.ovfilter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c71100176.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c)) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1) 
	end 
end
function c71100176.rmlimit(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c==e:GetHandler() and r&REASON_EFFECT~=0 and re:GetOwnerPlayer()~=tp
end


