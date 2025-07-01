--遂夜
if not pcall(function() require("expansions/script/c71000111") end) then
	if not pcall(function() require("script/c71000111") end) then
		require("c71000111")
	end
end
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--SynchroSummon
	local e1=bm.e.BlazingArmsSynchroEffect(c,m)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.syncon)
	e1:SetTarget(cm.syntg)
	e1:SetOperation(cm.synop)
end
function cm.synf(c,tc,tuner)
	local mg=Group.FromCards(tc,tuner)
	return c:IsSynchroSummonable(tuner,mg)
end
function cm.cfilter(c,tp,ec)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSummonPlayer(1-tp) and Duel.IsExistingMatchingCard(cm.synf,tp,LOCATION_EXTRA,0,1,nil,c,ec)
end
function cm.syncon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,e:GetHandler())
end
function cm.disfilter(c,g)
	return g:IsContains(c)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(cm.cfilter,nil,tp,e:GetHandler())
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.disfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		local syng=Duel.GetMatchingGroup(cm.synf,tp,LOCATION_EXTRA,0,nil,tc,c)
		if syng:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=syng:Select(tp,1,1,nil):GetFirst()
			Duel.SynchroSummon(tp,sc,c,Group.FromCards(c,tc))
		end
	end
end