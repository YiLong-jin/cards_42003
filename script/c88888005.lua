--破魂枪手 邪眼皇埃比鲁
function c88888005.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c88888005.ovfilter,aux.Stringid(88888005,0),3,c88888005.xyzop)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c88888005.imecon)
	e1:SetValue(c88888005.efilter)
	c:RegisterEffect(e1)
	--mat
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c88888005.matg)
	e2:SetOperation(c88888005.maop)
	c:RegisterEffect(e2)
	--get effect
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCondition(c88888005.macon)
	c:RegisterEffect(e3)
end
function c88888005.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(5) and c:IsSetCard(0x8980)
end
function c88888005.mafilter(c)
	return c:GetOriginalType(TYPE_LINK)
end
function c88888005.xyzop(e,tp,chk,mc)
	local og=mc:GetOverlayGroup()
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) and og:IsExists(Card.IsType,1,nil,TYPE_LINK) end
	local sc=og:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_LINK):GetFirst()
	Duel.SendtoGrave(sc,REASON_COST)
end
function c88888005.imecon(e)
	return e:GetHandler():GetOverlayCount()>=6
end
function c88888005.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c88888005.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end
function c88888005.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsCanOverlay() and c:IsFaceup() then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc:CancelToGrave()
		Duel.Overlay(c,tc)
	end
end
function c88888005.macon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0x8980)
end