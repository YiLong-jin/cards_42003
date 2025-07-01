--少女的集会
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCondition(cm.ctcon)
	e7:SetOperation(cm.ctop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function cm.drf(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if Duel.IsExistingMatchingCard(cm.drf,p,LOCATION_MZONE,0,1,nil) then
			Duel.Draw(p,1,REASON_EFFECT)
		end
	end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.drf,1,nil)
end
function cm.sf(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(4) and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.drf,nil)
	for p=0,1 do
		local sg=Duel.GetMatchingGroup(cm.sf,p,LOCATION_DECK,0,nil)
		if g:IsExists(Card.IsSummonPlayer,1,nil,p) and #sg>0 and Duel.SelectYesNo(p,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_OPERATECARD)
			local sg=sg:Select(p,1,1,nil)
			local tc=sg:GetFirst()
			if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(p,1190,1191)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,tc)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
