--未曾设想的结盟
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.cf(tp,loc,chk,e)
	local op_loc=(loc==LOCATION_MZONE or loc==LOCATION_GRAVE) and loc or 0
	local g=Duel.GetMatchingGroup(Card.IsLevel,tp,loc,op_loc,nil,4)
	if loc==LOCATION_MZONE then 
		g=g:Filter(Card.IsDestructable,nil) 
	elseif loc==LOCATION_GRAVE then 
		g=g:Filter(Card.IsAbleToDeck,nil)
	elseif loc==LOCATION_DECK then 
		g=g:Filter(Card.IsAbleToRemove,nil)
	elseif loc==LOCATION_HAND then 
		g=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false) 
	end
	if chk>0 then 
		return g 
	else return #g>0 end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.cf(tp,LOCATION_MZONE,0) and cm.cf(tp,LOCATION_GRAVE,0) and cm.cf(tp,LOCATION_DECK,0) and cm.cf(tp,LOCATION_HAND,0,e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cm.cf(tp,LOCATION_MZONE,1),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,cm.cf(tp,LOCATION_GRAVE,1),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rflag=false
	local dg=cm.cf(tp,LOCATION_MZONE,1)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=dg:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
			rflag=true
		end
	end
	dg=cm.cf(tp,LOCATION_GRAVE,1)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=dg:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			if rflag then Duel.BreakEffect() end
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			rflag=true
		end
	end
	dg=cm.cf(tp,LOCATION_DECK,1)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=dg:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			if rflag then Duel.BreakEffect() end
			local tc=g:GetFirst()
			if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then 
				c:SetCardTarget(tc)
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			end
		end
	end
	dg=cm.cf(tp,LOCATION_HAND,1,e)
	if #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=dg:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			if rflag then Duel.BreakEffect() end
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.thf(c,rc)
	return c:GetFlagEffect(m)>0 and rc:IsHasCardTarget(c)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thf,tp,LOCATION_REMOVED,0,nil,c)
	if #g>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
	Duel.Destroy(c,REASON_EFFECT)
end