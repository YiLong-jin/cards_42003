--坠落惶灵族·祖灵之王
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,6,9),1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.linktg)
	e2:SetOperation(cm.linkop)
	c:RegisterEffect(e2)
end
function cm.filter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c)
	return c:IsFaceup()
end
function cm.fselect(c,tp)
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
	mg:AddCard(c)
	return mg:CheckSubGroup(cm.matfilter,1,#mg,tp,c)
end
function cm.matfilter(sg,tp,c)
	if not sg:IsContains(c) then return false end
	return Duel.IsExistingMatchingCard(cm.linkfilter,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function cm.linkfilter(c,mg)
	return c:IsRace(RACE_BEAST) and c:IsXyzSummonable(mg,#mg,#mg)
end
function cm.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:IsExists(cm.fselect,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:FilterSelect(tp,cm.fselect,1,1,nil,tp)
	if not g then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.AdjustAll()
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<#g then return end
	local exg=Duel.GetMatchingGroup(cm.linkfilter2,tp,LOCATION_EXTRA,0,nil)
	local lg=exg:Filter(cm.ovfilter,nil,tp,g)
	if lg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lc=lg:Select(tp,1,1,nil):GetFirst()
		local fg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
		local sg=fg:SelectSubGroup(tp,cm.gselect,false,1,7,lc,g)
		Duel.XyzSummon(tp,lc,sg,#sg,#sg)
	end
end
function cm.linkfilter2(c)
	return c:IsRace(RACE_BEAST)
end
function cm.ovfilter(c,tp,sg)
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(cm.gselect,1,#mg,c,sg)
end
function cm.gselect(sg,c,g)
	if sg:Filter(aux.IsInGroup,nil,g):GetCount()~=g:GetCount() then return false end
	return c:IsXyzSummonable(sg,#sg,#sg)
end
