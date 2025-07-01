--破魂枪手 邪眼埃比鲁
function c88888004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c88888004.ovfilter,aux.Stringid(88888004,0),3,nil)
	c:EnableReviveLimit()
	--x mat
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c88888004.matg)
	e1:SetOperation(c88888004.maop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88888004.imecon)
	e2:SetValue(c88888004.efilter)
	c:RegisterEffect(e2)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888004,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetCondition(c88888004.ovlcon)
	e3:SetTarget(c88888004.ovltg)
	e3:SetOperation(c88888004.ovlop)
	c:RegisterEffect(e3)
	--get effect
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e4:SetCondition(c88888004.ovlcon2)
	c:RegisterEffect(e4)
end
function c88888004.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8980) and c:IsLink(4)
end
function c88888004.mafilter(c)
	return c:IsCanOverlay()
end
function c88888004.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c88888004.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c88888004.mafilter,tp,LOCATION_ONFIELD,0,c)
	if c:IsFaceup() then
		for tc in aux.Next(g) do 
			if tc and not tc:IsImmuneToEffect(e) then
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,Group.FromCards(tc))
			end
		end
	end
end
function c88888004.imecon(e)
	return e:GetHandler():GetOverlayCount()>=5
end
function c88888004.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c88888004.ovlcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c88888004.ovltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return c:IsType(TYPE_XYZ) and rc:IsRelateToEffect(re) and rc:IsCanOverlay() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c88888004.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup()
		and rc:IsRelateToEffect(re) and not rc:IsImmuneToEffect(e) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		rc:CancelToGrave()
		Duel.Overlay(c,rc)
	end
end
function c88888004.ovlcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsSetCard(0x8980)
end