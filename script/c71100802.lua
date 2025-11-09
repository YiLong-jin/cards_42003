--复杂三角形·代欧奇希斯
local s, id = GetID()

function s.initial_effect(c)
	-- syoukansuru
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	
	--redirect
	aux.AddBanishRedirect(c)
	
	-- ririsu
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e3:SetCountLimit(2, id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end


function s.ntcon(e, c, minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE)>0
end



function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(Card.IsPreviousLocation, 1, nil, LOCATION_ONFIELD)
end
function s.lkfilter(c,mc)
	return c:IsLinkSummonable(nil,mc)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	local loc = c:GetLocation()
	
	if chk == 0 then
		if loc == LOCATION_HAND then
			return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil,c)
		elseif loc == LOCATION_REMOVED then
			return c:IsAbleToHand()
		end
		return false
	end
	
	if loc == LOCATION_HAND then
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
	elseif loc == LOCATION_REMOVED then
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 1, 0, 0)
	end
end


function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local loc = c:GetLocation()
	
	if loc == LOCATION_HAND then
		if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
		local g=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_EXTRA,0,nil,c)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
		end
		end
	elseif loc == LOCATION_REMOVED then
		Duel.SendtoHand(c, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, c)
	end
end