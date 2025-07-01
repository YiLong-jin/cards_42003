--公司神明
local m=71100004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,cm.ovfilter,aux.Stringid(m,0),99,cm.xyzop)
	c:EnableReviveLimit()
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.mtcon)
	e1:SetOperation(cm.mtop)
	c:RegisterEffect(e1)
	--limplayer
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71100004)
	e2:SetCost(cm.atcost)
	e2:SetTarget(cm.attg)
	e2:SetOperation(cm.atop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,71100014)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7d0) and not c:IsCode(m) and c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function cm.costfilter(c)
	return c:IsSetCard(0x7d0) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ)
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup():FilterCount(cm.costfilter,nil)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g1=e:GetHandler():GetOverlayGroup():FilterCount(cm.costfilter,nil)
	e:SetLabel(g-g1)
end
function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.AnnounceType(1-tp)
	if e:GetLabel()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(rc)
		e1:SetOperation(cm.aclimit)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetCondition(cm.econ1)
		e2:SetValue(cm.elimit1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCondition(cm.econ2)
		e3:SetValue(cm.elimit2)
		Duel.RegisterEffect(e3,tp)
		local e4=e2:Clone()
		e4:SetCondition(cm.econ3)
		e4:SetValue(cm.elimit3)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.aclimit(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if re:IsActiveType(TYPE_MONSTER) and e:GetLabel()~=0x0 then
		e:GetHandler():RegisterFlagEffect(71100004,RESET_PHASE+PHASE_END,0,1)
	end
	if re:IsActiveType(TYPE_SPELL) and e:GetLabel()~=0x1 then
		e:GetHandler():RegisterFlagEffect(71100005,RESET_PHASE+PHASE_END,0,1)
	end
	if re:IsActiveType(TYPE_TRAP) and e:GetLabel()~=0x2 then
		e:GetHandler():RegisterFlagEffect(71100006,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.econ1(e)
	return e:GetHandler():GetFlagEffect(71100004)~=0
end
function cm.elimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.econ2(e)
	return e:GetHandler():GetFlagEffect(71100005)~=0
end
function cm.elimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.econ3(e)
	return e:GetHandler():GetFlagEffect(71100006)~=0
end
function cm.elimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end
function cm.rmfilter(c,e,tp,xyz)
	return c:IsAbleToRemove() and c~=xyz and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return cm.rmfilter(chkc,e,tp,c) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x7d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsAbleToRemove()) then return end 
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
		if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
			if tc1 then 
				Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP) 
			end
		end
	end
end






