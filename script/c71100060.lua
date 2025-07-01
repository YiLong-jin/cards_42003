--公司安保·白血生骸
local m=71100060
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,nil,nil,99) 
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
	--set 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.srcon1)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2) 
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(cm.srcon2)
	c:RegisterEffect(e4) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,71100061)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3) 
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
function cm.srcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0 and not (Duel.GetFlagEffect(tp,71100031)~=0 or e:GetHandler():IsHasEffect(71100031))
end
function cm.srcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0 and (Duel.GetFlagEffect(tp,71100031)~=0 or e:GetHandler():IsHasEffect(71100031))
end
function cm.srfil(c) 
	if not (c:IsType(TYPE_TRAP) and c:IsSetCard(0x7d0,0x7d2)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end 
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(e,ep,tp)
	return not (tp~=ep and e:IsActiveType(TYPE_MONSTER))
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.srfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end 
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local cg=g:GetFirst()
	local ctype=0
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.SetChainLimit(cm.chlimit1)
	elseif tc:IsType(TYPE_SPELL) then
		Duel.SetChainLimit(cm.chlimit2)
	elseif tc:IsType(TYPE_TRAP) then
		Duel.SetChainLimit(cm.chlimit3)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chlimit1(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function cm.chlimit2(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_SPELL)
end
function cm.chlimit3(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_TRAP)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
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
