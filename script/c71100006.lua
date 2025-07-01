--菌兽天使 亚蒂密丝
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--link summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.linktg)
	e3:SetOperation(cm.linkop)
	c:RegisterEffect(e3)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(0x7d0,0x7d1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		local lv=1
		if tc:IsLevelAbove(2) then 
			lv=1-2*Duel.SelectOption(tp,aux.Stringid(71100266,0),aux.Stringid(71100266,1))
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x7d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c)
	return c:IsFaceup()
end
function cm.fselect(sg,tp)
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(cm.matfilter,1,#mg,tp,sg)
end
function cm.matfilter(sg,tp,g)
	if sg:Filter(aux.IsInGroup,nil,g):GetCount()~=g:GetCount() then return false end
	return Duel.IsExistingMatchingCard(cm.linkfilter,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function cm.linkfilter(c,mg)
	return c:IsSetCard(0x7d0) and c:IsLinkSummonable(mg,nil,#mg,#mg)
end
function cm.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if e:GetHandler():GetOverlayCount()<ft then ft=e:GetHandler():GetOverlayCount() end
	if chk==0 then return ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and mg:CheckSubGroup(cm.fselect,1,ft,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp)
	local xyzmg=e:GetHandler():GetOverlayGroup()
	local ct=Duel.SendtoGrave(xyzmg,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<ft then ft=ct end
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) or ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:SelectSubGroup(tp,cm.fselect,false,1,ft,tp)
	if not g then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<#g then return end
	local exg=Duel.GetMatchingGroup(cm.linkfilter2,tp,LOCATION_EXTRA,0,nil)
	local lg=exg:Filter(cm.ovfilter,nil,tp,g)
	if lg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lc=lg:Select(tp,1,1,nil):GetFirst()
		local fg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
		local sg=fg:SelectSubGroup(tp,cm.gselect,false,1,7,lc,g)
		Duel.LinkSummon(tp,lc,sg,nil,#sg,#sg)
	end
end
function cm.linkfilter2(c)
	return c:IsSetCard(0x7d0)
end
function cm.ovfilter(c,tp,sg)
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(cm.gselect,1,#mg,c,sg)
end
function cm.gselect(sg,c,g)
	if sg:Filter(aux.IsInGroup,nil,g):GetCount()~=g:GetCount() then return false end
	return c:IsLinkSummonable(sg,nil,#sg,#sg)
end
