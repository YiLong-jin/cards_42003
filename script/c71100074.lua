--散布V城深层的侵蚀
local m = 71100074
local cm = _G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.conf(c)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.conf,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>1
end
function cm.get_zone(c,seq)
	local zone=0
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) then zone=bit.replace(zone,0x1,seq+1) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) then zone=bit.replace(zone,0x1,seq-1) end
	if seq==0 and c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then zone=bit.replace(zone,0x1,5) end
	if seq==1 and c:IsLinkMarker(LINK_MARKER_BOTTOM) then zone=bit.replace(zone,0x1,5) end
	if seq==2 then 
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then zone=bit.replace(zone,0x1,5) end
		if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then zone=bit.replace(zone,0x1,6) end
	end
	if seq==3 and c:IsLinkMarker(LINK_MARKER_BOTTOM) then zone=bit.replace(zone,0x1,6) end
	if seq==4 and c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then zone=bit.replace(zone,0x1,6) end
	return zone
end
function cm.spfilter(c,e,tp,seq)
	if not (c:IsType(TYPE_LINK) and c:IsSetCard(0x7d0)) then return false end
	local zone=cm.get_zone(c,seq)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and Duel.GetLocationCountFromEx(tp,tp,nil,c,zone)>0
end
function cm.targetfilter(c,e,tp)
	local seq=c:GetSequence()
	return cm.conf(c) and c:IsCanChangePosition() and c:IsAttackPos() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,seq)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.conf(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.targetfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.targetfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsControler(tp) and tc:IsRelateToEffect(e) and tc:IsAttackPos() and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,seq)
		local sc=g:GetFirst()
		if sc then 
			local zone=cm.get_zone(sc,seq)
			if zone~=0 and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP,zone) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e3:SetValue(aux.TRUE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
	end
end