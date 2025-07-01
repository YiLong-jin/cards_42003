--生存的法则 VARIANTE
local cm,m,o=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,71100416)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.mattg)
	e2:SetOperation(cm.matop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(71100034)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.desfilter(c)
	return not cm.cfilter(c)
end
function cm.spfilter(c,e,tp,g,mchk)
	if (mchk==1 and not c:IsCode(71100030)) or (mchk==2 and not c:IsCode(71100000)) or (mchk==3 and not c:IsCode(71100004)) or (mchk==4 and not c:IsCode(71100025)) then return false end 
	if not c:IsCanBeSpecialSummoned(e,0,tp,true,false) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	else
		return Duel.GetMZoneCount(tp,g)>0
	end
end
function cm.spchkf(c,e,tp,fchk)
	if not cm.cfilter(c) then return false end 
	local tgchk=true 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if (fchk and Duel.Destroy(g,REASON_EFFECT)==0) or (#g==0 and not fchk) then tgchk=false end
	for Index=1,4 do 
		local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,g,Index)
		if #spg<1 then 
			tgchk=false 
			break 
		end
		if fchk then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:Select(tp,1,1,nil)
			if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)==0 then 
				tgchk=false 
				break 
			else 
				Duel.BreakEffect()
			end
		end
	end
	return tgchk
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,4)
		and Duel.IsExistingMatchingCard(cm.spchkf,tp,LOCATION_MZONE,0,1,nil,e,tp,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.spchkf,tp,LOCATION_MZONE,0,1,1,nil,e,tp,false)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	cm.spchkf(tc,e,tp,true)
end
function cm.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7d0) and c:IsType(TYPE_XYZ)
end
function cm.matfilter(c)
	return c:IsCanOverlay()
end
function cm.thfilter(c)
	return c:IsSetCard(0x7d2) and c:IsType(TYPE_SPELL) and (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS)) and c:IsAbleToHand()
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.xyzfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.matfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
