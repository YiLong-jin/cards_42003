--V城兽耳爆发
function c71100059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100059+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c71100059.activate)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100059,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71100059.condition)
	e2:SetTarget(c71100059.target)
	e2:SetOperation(c71100059.operation)
	c:RegisterEffect(e2)  
end
function c71100059.spfilter(c,e,tp)
	return c:IsSetCard(0x7d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c71100059.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(c71100059.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(71100059,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c71100059.filter(c)
	return c:IsSetCard(0x7d0) and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_COST)) 
end
function c71100059.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (re and re:IsActivated()) then return false end
	return eg:IsExists(c71100059.filter,1,nil,tp)
end
function c71100059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71100059.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end