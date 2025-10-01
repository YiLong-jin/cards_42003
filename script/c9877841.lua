--叛逆特警-奔雷
function c9877841.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9877841.mfilter,1,1)
	c:EnableReviveLimit() 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877841,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9877841) 
	e1:SetTarget(c9877841.sptg)
	e1:SetOperation(c9877841.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877841,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9877841) 
	e2:SetCost(c9877841.lkcost)
	e2:SetTarget(c9877841.lktg)
	e2:SetOperation(c9877841.lkop)
	c:RegisterEffect(e2)
end
function c9877841.mfilter(c)
	return c:IsLinkSetCard(0x17ec) and c:IsLinkRace(RACE_MACHINE)
end 
function c9877841.spfil(c,e,tp)
	return c:IsSetCard(0x17ec) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877841.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9877841.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9877841.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9877841.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
		if Duel.GetTurnPlayer()==tp and c:IsRelateToEffect(e) then 
			Duel.BreakEffect()
			Duel.SendtoGrave(c,REASON_EFFECT)
		end 
	end
end
function c9877841.lkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.CheckLPCost(tp,2000) end 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	Duel.PayLPCost(tp,2000)
end
function c9877841.lkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x17ec)
end
function c9877841.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877841.lkfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9877841.lkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9877841.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end




