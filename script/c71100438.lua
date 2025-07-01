--V城编年史~活死黎明
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.Dead_souls_pawn=true --「死魂棋子」记述
function s.tgfilter(c)
	return (c.Dead_souls_pawn or c:IsSetCard(0x7d8)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(s.rmfilter,c:GetControler(),LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.rmfilter(c,code)
	return (c.Dead_souls_pawn or c:IsSetCard(0x7d8)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and not c:IsCode(code)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	local rc=rg:GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) and rc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then 
		Duel.BreakEffect()
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO+TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
