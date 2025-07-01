--追逐的舞步
local cm,m,offset=GetID()
function c20003194.initial_effect(c)
	--Activate
	--Activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)

end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>1 then return false end
	local tc=eg:GetFirst()
	if not tc then return false end
	e:SetLabelObject(tc)
	return tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x417)
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x417)
end
function cm.spfilter3(c,e,tp)
	return c:IsSetCard(0x417) and c:IsType(TYPE_MONSTER)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then 
		if not tc then return false end
		local achk=false
		if tc:IsType(TYPE_SYNCHRO) then
			achk=achk or Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) 
		end
		if not tc:IsType(TYPE_SYNCHRO) then 
			achk=achk or (Duel.IsExistingMatchingCard(cm.spfilter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		end
		return achk
		end
	local cate=0
	if not tc:IsType(TYPE_SYNCHRO) then 
		cate=cate+CATEGORY_SPECIAL_SUMMON 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
	if tc:IsType(TYPE_SYNCHRO) then 
		cate=cate+CATEGORY_TOHAND+CATEGORY_SEARCH 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	e:SetCategory(cate)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if (not tc) or (not tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x417)) then return end
	if not tc:IsType(TYPE_SYNCHRO) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local zg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter3),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #zg>0 then Duel.SpecialSummon(zg,0,tp,tp,false,false,POS_FACEUP) end
	end
	if tc:IsType(TYPE_SYNCHRO) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
end


function c20003194.thfilter(c)
	return c:IsSetCard(0x417) and c:IsAbleToHand()
end
function c20003194.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20003194.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20003194,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end