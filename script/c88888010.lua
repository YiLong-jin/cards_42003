--破魂枪兵 比萨米拉
function c88888010.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FIEND),2,99)
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c88888010.efilter)
	c:RegisterEffect(e0)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c88888010.con)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88888010)
	e2:SetTarget(c88888010.xyztg)
	e2:SetOperation(c88888010.xyzop)
	c:RegisterEffect(e2)
end
function c88888010.efilter(e,te)
	return te:IsActiveType(TYPE_XYZ)
end
function c88888010.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c88888010.con(e)
	return Duel.IsExistingMatchingCard(c88888010.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c88888010.xyzfilter(c,lc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and lc:GetLinkedGroup():IsExists(Card.IsCanOverlay,1,c)
end
function c88888010.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_XYZ) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c88888010.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c88888010.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c)
end
function c88888010.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		local g=c:GetLinkedGroup():Filter(Card.IsCanOverlay,c)
		for oc in aux.Next(g) do 
			if oc and not oc:IsImmuneToEffect(e) then
				local og=oc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(tc,Group.FromCards(oc))
			end
		end
	end
end