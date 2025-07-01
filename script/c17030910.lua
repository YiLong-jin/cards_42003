--真实探究者·浮士德
function c17030910.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	c:EnableReviveLimit()
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17030910,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c17030910.countercost)
	e1:SetTarget(c17030910.countertg)
	e1:SetOperation(c17030910.counterop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17030910,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c17030910.spcon)
	e2:SetTarget(c17030910.sptg)
	e2:SetOperation(c17030910.spop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c17030910.reptg)
	c:RegisterEffect(e3)
end
function c17030910.countercost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17030910.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanAddCounter(0x1,1)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,c,0x1,1) end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x1,1)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,0,0)
end
function c17030910.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x1,1)
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x1,1) then
			tc:AddCounter(0x1,1)
		end
	end
end
function c17030910.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and e:GetHandler():GetCounter(0x1)>0 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveCounter(ep,0x1,1,REASON_EFFECT)
		return true
	else return false end
end
function c17030910.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17030910.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) 
		and Duel.IsExistingMatchingCard(c17030910.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c17030910.spfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c17030910.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c17030910.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17030910.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c17030910.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17030910,2))
		local cg=g:Select(tp,1,1,nil)
		Duel.HintSelection(cg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c17030910.spfilter,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetCode(),e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
