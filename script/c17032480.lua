--新序系12 以太马赫斯
function c17032480.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,c17032480.ovfilter,aux.Stringid(17032480,1),2,c17032480.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17032480,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c17032480.target)
	e1:SetOperation(c17032480.operation)
	c:RegisterEffect(e1)
end
function c17032480.eftg(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
c17032480.New_Order=12
function c17032480.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and (c:IsDiscardable() or c:IsAbleToHand())
end
function c17032480.ovfilter(c)
	return c:IsFaceup() and c.New_Order and c:IsRank(10)
end
function c17032480.xyzop(e,tp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,17032500)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c17032480.cfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c17032480.cfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,17032500)
		fe:UseCountLimit(tp)
		Duel.SendtoHand(tc,nil,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
	end
end
function c17032480.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17032480.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g1=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	local g2=e:GetHandler():GetOverlayGroup():Filter(c17032480.spfilter,nil,e,tp)
	if chk==0 then return ft>=#g1 and #g1==#g2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#g1,tp,LOCATION_HAND)
end
function c17032480.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=e:GetHandler():GetOverlayGroup():Filter(c17032480.spfilter,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fid=e:GetHandler():GetFieldID()
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	e:GetHandler():RegisterFlagEffect(17032481,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(17032480,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		sg:AddCard(tc)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	sg:KeepAlive()
	sg:AddCard(e:GetHandler())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c17032480.descon)
	e1:SetOperation(c17032480.desop)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg)
	Duel.RegisterEffect(e1,tp)
end
function c17032480.desfilter(c,fid)
	return c:GetFlagEffectLabel(17032480)==fid 
end
function c17032480.matfilter(c,fid)
	return c:GetFlagEffectLabel(17032481)==fid 
end
function c17032480.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c17032480.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c17032480.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local cc=e:GetLabelObject():Filter(c17032480.matfilter,nil,e:GetLabel()):GetFirst()
	local dg=sg:Filter(c17032480.desfilter,nil,e:GetLabel())
	sg:DeleteGroup()
	if dg:GetCount()>0 and cc then
		Duel.Overlay(cc,dg)
	end
end
