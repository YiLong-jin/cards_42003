--The Savior And The Destroyer
local m=99970030
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.matfilter1,aux.NonTuner(Card.IsType,TYPE_LINK),1,99)
	c:EnableReviveLimit()


	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetLabel(12)
	e0:SetCondition(cm.sycon)
	e0:SetOperation(cm.syop)
	c:RegisterEffect(e0)


	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)

end





function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.thfilter(c)
	return c:IsSetCard(0x1661) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.mgfilter(c,e,tp,xyzc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not aux.MustMaterialCounterFilter(c,mg)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.SendtoGrave(c,REASON_EFFECT)~=0 and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:FilterCount(aux.NecroValleyFilter(cm.mgfilter),nil,e,tp,tc,mg)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc1=mg:FilterSelect(tp,aux.NecroValleyFilter(cm.mgfilter),1,1,nil,e,tp,tc,mg):GetFirst()
			if tc1 then
			Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end



















function cm.matfilter1(c)
	return c:IsType(TYPE_XYZ)
end

function cm.stfilter1(c,tc)
	return c:IsType(TYPE_XYZ) and c:IsPosition(POS_FACEUP)
end
function cm.stfilter2(c,tc)
	return c:IsPosition(POS_FACEUP) and c:IsType(TYPE_LINK)
end
function cm.stfilterg(g,tp,tc,lv,smat)
	if smat then
		g:AddCard(smat)
	end
	local g1=g:Filter(cm.stfilter1,nil,tc)
	local g2=g:Filter(cm.stfilter2,nil,tc)
	local count=g:GetCount()
	local rk=g1:GetSum(Card.GetRank)
	local lk=g2:GetSum(Card.GetLink)*2
	local allk=rk+lk
	return g1:GetCount()==1 and g2:GetCount()==count-1 and allk==lv and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local lv=e:GetLabel()
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,lv,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,lv,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local lv=e:GetLabel()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,lv,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,lv,nil))
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end