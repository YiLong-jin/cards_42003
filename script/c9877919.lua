--黑江 觉醒
function c9877919.initial_effect(c)
	aux.AddCodeList(c,9877918,9877873)
	aux.AddLinkProcedure(c,c9877919.lfcheck,2,2)
	c:EnableReviveLimit()
	
	local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(9877919,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_QUICK_O) 
	e14:SetCode(EVENT_FREE_CHAIN) 
	e14:SetRange(LOCATION_MZONE)
	e14:SetHintTiming(0,TIMING_END_PHASE)
	e14:SetCountLimit(1,9877919)
	e14:SetTarget(c9877919.tgtg) 
	e14:SetOperation(c9877919.tgop) 
	c:RegisterEffect(e14) 
end
function c9877919.lfcheck(c)
	return c:IsLinkRace(RACE_SPELLCASTER)
end

function c9877919.tgfil(c) 
	return c:IsAbleToHand() and (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877918)) and c:IsFaceup()
end 
function c9877919.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877919.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c9877919.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877919.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
	   Duel.SendtoHand(sg,nil,REASON_EFFECT)  
	   Duel.ConfirmCards(1-tp,sg)
	end 
end 