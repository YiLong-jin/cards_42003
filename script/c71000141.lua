--龙之归海
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.f(c)
	return c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g>0 then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if oc>0 and (not Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_GRAVE,1,nil,TYPE_MONSTER)) and #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(8131171,0)) then
			local sg=hg:Select(tp,1,oc,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end