--死灵舞者继承
local m=71100241
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--return 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	--sps
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.tdfilter(c)
	return c:IsSetCard(0x7d8) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.tdfilter(c) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x17d7,3)
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local cc=g:Select(tp,1,1,nil):GetFirst()
		cc:AddCounter(0x17d7,3)
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.costfilter(c,e,tp,mg)
	if not (c:IsLevelAbove(0) and c:IsSetCard(0x7d8) and c:IsType(TYPE_MONSTER)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)) then return false end
	return mg:CheckSubGroup(cm.fselect,1,c:GetLevel(),tp,c:GetLevel())
end
function cm.fselect(g,tp,lv)
	local mg=g:Clone()
	if Duel.GetMZoneCount(tp,mg)>0 then
		if lv<=0 then
			return g:GetCount()==1
		else
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetOriginalLevel,lv)
		end
	else return false end
end
function cm.relfilter(c,e)
	return c:IsLevelAbove(1) and c:IsReleasableByEffect() and c:IsRace(RACE_ZOMBIE) and not c:IsImmuneToEffect(e)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetReleaseGroup(tp,true):Filter(cm.relfilter,nil,e)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if mg:GetCount()==0 then return false end
		return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
	Duel.SetTargetCard(g)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local mg=Duel.GetReleaseGroup(tp,true):Filter(cm.relfilter,nil,e)
	if mg:GetCount()==0 then return end
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:SelectSubGroup(tp,cm.fselect,false,1,tc:GetLevel(),tp,tc:GetLevel())
		if g and g:GetCount()>0 then
			if Duel.Release(g,REASON_EFFECT)~=0 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
end