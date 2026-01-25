--遗留下的唯一宝物
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877895,9877897,9878087,9878079,9878084)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCountLimit(1)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(0x08)
	e0:SetCondition(cm.descon)
	e0:SetTarget(cm.destg)
	e0:SetOperation(cm.desop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(0x08)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end

function cm.splist(c)
	return aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877897) or aux.IsCodeListed(c,9878079) or aux.IsCodeListed(c,9878084) or aux.IsCodeListed(c,9878087)
end

function cm.condfilter(c,tp)
	return c:IsSummonPlayer(tp) and cm.splist(c)
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.condfilter,1,nil,tp)
end

function cm.tgdfilter(c)
	return c:IsAbleToHand() and cm.splist(c) and c:IsType(0x1)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgdfilter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgdfilter,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.tgsfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and cm.splist(c)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x02,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x02,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end